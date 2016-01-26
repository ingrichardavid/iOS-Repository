//
//  ViewController.swift
//  JSONWebExample
//
//  Created by Ing. Richard José David González on 25/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Controller to consume JSON of a Web. Implement UIViewController
*/
class ViewController: UIViewController {

    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var lblIp: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblRegionCode: UILabel!
    @IBOutlet weak var lblRegionName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblZipCode: UILabel!
    @IBOutlet weak var lblTimeZone: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to consult data.
    @IBAction func btnConsult(sender: UIButton) {
        
        self.configuration(false)
        self.consumeJSON()
        
    }    
    
    //MARK: - Methods: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods: Self.
    
    ///Function to consume JSON Web https://freegeoip.net/json/.
    private func consumeJSON() {
    
        let url: NSURL = NSURL(string: "https://freegeoip.net/json/")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (nsData, response, error) -> Void in
            
            guard error == nil else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.configuration(true)
                })
                self.presentViewController(self.informationMessage("An error has occurred!"), animated: true, completion: nil)
                
                return
            
            }
            
            guard let urlContent = nsData else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.configuration(true)
                })
                self.presentViewController(self.informationMessage("An error has occurred!"), animated: true, completion: nil)
                
                return
                
            }
            
            do {
                
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                
                let entityFreeGeoIp: EntityFreeGeoIp = EntityFreeGeoIp(anyObject: jsonResult)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.fillFields(entityFreeGeoIp)
                })
                
            } catch {
                self.presentViewController(self.informationMessage("JSON serialization failed!"), animated: true, completion: nil)                
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.configuration(true)
            })
            
        }
        
        task.resume()
    
    }
    
    ///Function to generate a information message.
    private func informationMessage(message: String) -> UIAlertController {
    
        let alertController: UIAlertController = UIAlertController(title: "Information message", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(acceptAction)
        
        return alertController
        
    }
    
    ///Initial configuration of the components.
    private func configuration(status: Bool) {
        
        self.viewBlock.hidden = status
        
        guard self.activityIndicator.isAnimating() == true else {
            
            self.activityIndicator.startAnimating()
        
            return
            
        }
        
        self.activityIndicator.stopAnimating()
        
    }
    
    ///Methods for fill fields of labels.
    private func fillFields(entityFreeGeoIp: EntityFreeGeoIp) {
    
        self.lblIp.text = "Protocolo de Internet: \(entityFreeGeoIp.ip!)"
        self.lblCountryCode.text = "Código de la Ciudad: \(entityFreeGeoIp.country_code!)"
        self.lblCountryName.text = "Nombre de la Ciudad: \(entityFreeGeoIp.country_name!)"
        self.lblRegionCode.text = "Código de la Región: \(entityFreeGeoIp.region_code!)"
        self.lblRegionName.text = "Nombre de la Región: \(entityFreeGeoIp.region_name!)"
        self.lblCity.text = "Ciudad: \(entityFreeGeoIp.city!)"
        self.lblZipCode.text = "Código Postal: \(entityFreeGeoIp.zip_code!)"
        self.lblTimeZone.text = "Zona Horaria: \(entityFreeGeoIp.time_zone!)"
        self.lblLatitude.text = "Latitud: \(entityFreeGeoIp.latitude!)"
        self.lblLongitude.text = "Longitud: \(entityFreeGeoIp.longitude!)"
    
    }

}

