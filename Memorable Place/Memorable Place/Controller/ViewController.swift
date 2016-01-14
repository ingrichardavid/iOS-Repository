//
//  ViewController.swift
//  Memorable Place
//
//  Created by Ing. Richard José David González on 11/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

/**
    ViewController to manage the map. Implements UIViewController and CLLocationManagerDelegate.
*/
class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Objects, Variables and Constants.
    
    ///To manipulate the current location of a user.
    var locationManager: CLLocationManager!
    
    ///Protocol to execute the functions implemented in the class TableViewController.
    var tableViewDelegate = tableViewControllerDelegate?()
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to select a new location.
    @IBAction func addLocation(sender: UILongPressGestureRecognizer) {
        
        guard sender.state == UIGestureRecognizerState.Began else {
            return
        }
        
        let touchPoint: CGPoint = sender.locationInView(self.mapView)
        let coordinate: CLLocationCoordinate2D = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        let location: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            
            guard error == nil else {
                print("Error: \(error)")
                return
            }
            
            let p = CLPlacemark(placemark: placemarks![0])
            let subThoroughfare: String = self.validateSubThoroughfare(p)
            let thoroughfare: String = self.validateThoroughfare(p)
            
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            if (subThoroughfare == "" && thoroughfare == "") {
                annotation.title = "Added \(NSDate())"
            } else {
                annotation.title = "\(subThoroughfare) \(thoroughfare)"
            }
            
            places.append(["name":annotation.title!,"latitude":"\(coordinate.latitude)","longitude":"\(coordinate.longitude)"])
            self.tableViewDelegate?.reloadData()
            
            self.mapView.addAnnotation(annotation)
            
        }
        
    }
    
    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurationLocationManager()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods: CLLocationManagerDelegate.
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.drawMap(locations[0])
    }
    
    //MARK: - Methods: Self.
    
    ///Initial configuration for object locationManager.
    private func configurationLocationManager() {
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (activePlace == -1 ){
            
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
        } else {
            
            let latitude: Double = Double(places[activePlace]["latitude"]!)!
            let longitude: Double = Double(places[activePlace]["longitude"]!)!
            let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let coordinate2D: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
            self.drawMap(location)
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                
                guard error == nil else {
                    print("Error: \(error)")
                    return
                }
                
                let p = CLPlacemark(placemark: placemarks![0])
                let subThoroughfare: String = self.validateSubThoroughfare(p)
                let thoroughfare: String = self.validateThoroughfare(p)
                
                let annotation: MKPointAnnotation = MKPointAnnotation()
                annotation.coordinate = coordinate2D
                
                if (subThoroughfare == "" && thoroughfare == "") {
                    annotation.title = "Added \(NSDate())"
                } else {
                    annotation.title = "\(subThoroughfare) \(thoroughfare)"
                }
                
                self.mapView.addAnnotation(annotation)
                
            }
            
            
        }
        
        
    
    }

    ///Function to draw location on the map.
    private func drawMap(location: CLLocation) {
    
        let latitude: CLLocationDegrees = location.coordinate.latitude
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let coordinate2D: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let latitudeDelta: CLLocationDegrees = 0.01
        let longitudeDelta: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate2D, span)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    ///Function to validate existence of subThoroughfare.
    private func validateSubThoroughfare(placemark: CLPlacemark) -> String {
    
        guard placemark.subThoroughfare == nil else {
            return placemark.subThoroughfare!
        }
        
        return ""
    
    }
    
    ///Function to validate existence of thoroughfare.
    private func validateThoroughfare(placemark: CLPlacemark) -> String {
        
        guard placemark.thoroughfare == nil else {
            return placemark.thoroughfare!
        }
        
        return ""
        
    }
    

}

