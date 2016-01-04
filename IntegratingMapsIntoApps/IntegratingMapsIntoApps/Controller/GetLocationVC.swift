//
//  ViewController.swift
//  IntegratingMapsIntoApps
//
//  Created by Ing. Richard José David González on 13/12/15.
//  Copyright © 2015 Ing. Richard J. David G. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/**
    Implements UIViewController and MKMapViewDelegate. It contains the methods needed to determine the current location of a user and select a new point, and then calculate the route between the current location of the user and the newly selected point.
*/
class GetLocationVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var mapView: MKMapView!

    //MARK: - Objects, Variables and Constants.
    
    ///Street where the user is currently.
    var street: String? = String()
    
    ///Current coordinates.
    var currentLocation: MKMapItem = MKMapItem()
    
    ///Selected coordinates.
    var newLocation: MKMapItem = MKMapItem()
    
    ///This object allows for the user's current location.
    var locationManager: CLLocationManager = CLLocationManager()
    
    ///Variable to control the pin number that can appear on the map.
    var i: Int = 0
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to get the current user location by pressing the button my location.
    @IBAction func goToMyLocation(sender: UIBarButtonItem) {
        self.getCurrentLocation()
    }
    
    ///Function to get a new cue point.
    @IBAction func newLocation(sender: UILongPressGestureRecognizer) {
        
        if (self.mapView.annotations.count < 2) {
            
            let touchPoint = sender.locationInView(self.mapView)
            let newCoordinate: CLLocationCoordinate2D = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            let newLocation: CLLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: {(placemarks, error) -> Void in
                
                if (error != nil) {
                    print(error)
                } else {
                    
                    let placeMark: CLPlacemark = placemarks![0] as CLPlacemark
                    
                    let annotation: MKPointAnnotation =  MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = self.validateTitle(placeMark)
                    annotation.subtitle = self.validateSubTitle(placeMark)
                    
                    self.mapView.addAnnotation(annotation)
                    self.mapView.selectAnnotation(self.mapView.annotations.last!,animated: true)
                    
                }
                
            })
            
            let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(newCoordinate.latitude, newCoordinate.longitude)
            let initialPlacemark: MKPlacemark = MKPlacemark(coordinate: locationCoordinate, addressDictionary: nil)
            self.currentLocation = MKMapItem(placemark: initialPlacemark)
            
        }
        
    }
    
    ///Function to display the route between the selected coordinates.
    @IBAction func showRoute(sender: UIBarButtonItem) {
        
        if (self.validation()) {
            
            let request = MKDirectionsRequest()
            
            request.source = self.currentLocation
            request.destination = self.newLocation
            request.requestsAlternateRoutes = false
            
            let directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
                
                if error != nil {
                    print("Error: \(error)")
                } else {
                    
                    let overlays = self.mapView.overlays
                    self.mapView.removeOverlays(overlays)
                    
                    for route in response!.routes {
                        
                        self.mapView.addOverlay(route.polyline,
                            level: MKOverlayLevel.AboveRoads)
                        
                        for next  in route.steps {
                            print(next.instructions)
                        }
                        
                    }
                    
                }
                
            }
        
        }
        
    }
    
    
    //MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurationLocationManager()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Methods: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.i++
        self.myLocation(locations.last!)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to capture location.")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.NotDetermined || status == CLAuthorizationStatus.Denied || status == CLAuthorizationStatus.Restricted {
            print("The application is not authorized to use location services.")
        }
        
    }

    //MARK: - Functions: Self.
    
    ///Object configuration locationManager for the user's current location.
    private func configurationLocationManager() {
        
        self.locationManager.delegate = self
        
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        if authorizationCode == CLAuthorizationStatus.NotDetermined &&  (self.locationManager.respondsToSelector("requestWhenInUseAuthorization") || self.locationManager.respondsToSelector("requestAlwaysAuthorization")) {
            
            guard NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil else {
                
                print("You NSLocationWhenInUseUsageDescription not found in the file property info.plist")
                return
                
            }
            
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        }
        
        self.getCurrentLocation()
        
    }
    
    ///Function to get the current location of the user.
    private func getCurrentLocation() {
        
        self.i = 0
        self.locationManager.startUpdatingLocation()
    
    }
    
    ///Function to indicate the current location of the user in the MapKit.
    private func myLocation(location: CLLocation) -> Void {
        
        if (self.i == 1) {
            
            self.drawMap(location)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                
                if (error != nil) {
                    print(error)
                } else {
                    
                    let placeMark: CLPlacemark = placemarks![0] as CLPlacemark
                    
                    let annotation: MKPointAnnotation =  MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    annotation.title = self.validateTitle(placeMark)
                    annotation.subtitle = self.validateSubTitle(placeMark)
                    
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotation(annotation)
                    self.mapView.selectAnnotation(self.mapView.annotations.last!, animated: true)
                    
                }
                
            })
            
            let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let finalPlacemark: MKPlacemark = MKPlacemark(coordinate: locationCoordinate, addressDictionary: nil)
            
            self.currentLocation = MKMapItem(placemark: finalPlacemark)
        
        }
        
    }
    
    ///Function to draw the map.
    private func drawMap(location: CLLocation) {
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let latitudeDelta: CLLocationDegrees = 0.003
        let longitudeDelta: CLLocationDegrees = 0.003
        let coordinateSpan: MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let coordinateRegion: MKCoordinateRegion = MKCoordinateRegionMake(locationCoordinate, coordinateSpan)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
    
    }
    
    ///Function to validate title.
    private func validateTitle(placeMark: CLPlacemark) -> String {
        
        guard placeMark.subLocality as String? == nil else {
            return placeMark.subLocality! as String
        }
        
        guard placeMark.locality as String? == nil else {
            return placeMark.locality! as String
        }
        
        guard placeMark.administrativeArea as String? == nil else {
            return placeMark.administrativeArea! as String
        }
        
        guard placeMark.country as String? == nil else {
            return placeMark.country! as String
        }
        
        return "Title"
        
    }
    
    ///Function to validate subtitle.
    private func validateSubTitle(placeMark: CLPlacemark) -> String {
        
        guard placeMark.name as String? == nil else {
            return placeMark.name! as String
        }
        
        guard placeMark.thoroughfare as String? == nil else {
            return placeMark.thoroughfare! as String
        }
        
        return "SubTitle"
        
    }
    
    ///Function To validate that you have selected a new coordinate.
    private func validation() -> Bool {
    
        if (self.mapView.annotations.count < 2) {
            
            let alertController: UIAlertController = UIAlertController(title: "Alert", message: "Please select a new coordinate.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alertController.addAction(alertAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return false
        
        }
        
        return true
    
    }

}

