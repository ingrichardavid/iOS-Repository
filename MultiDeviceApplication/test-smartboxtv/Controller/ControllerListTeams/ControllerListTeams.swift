//
//  ViewController.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/**
 Class responsible for administering the necessary methods of the view list teams. Implements UIViewController.
 */
class ControllerListTeams: UIViewController {
    
    //MARK: - Objects, Variables and Constants.
    
    ///Array for storing teams
    var teams: [Team] = [Team]()
    
    ///Function to back to consult country.
    @IBAction func backToConsultCountry(sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controllerConsultCountry = storyBoard.instantiateViewControllerWithIdentifier("ControllerConsultCountry") as! ControllerConsultCountry
        self.presentViewController(controllerConsultCountry, animated: true, completion: nil)
        
    }
    
    //MARK: - Functions: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        switch UIDevice.currentDevice().userInterfaceIdiom.rawValue {
        case 0:
            break
        case 1:
            let subViews = self.view.subviews
            for subview in subViews{
                if (subview.classForCoder == UIScrollView.classForCoder()){
                    subview.removeFromSuperview()
                }
            }
            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                ConfigurationScrollView().ipadDeviceLandscape(self, teams: self.teams)
            } else {
                ConfigurationScrollView().ipadDevicePortrait(self, teams: self.teams)
            }
            break
        default:
            break
        }
        
    }
    
    //MARK: - Functions: Self.
    
    ///Initial setup.
    private func initialSetup() {
        
        switch UIDevice.currentDevice().userInterfaceIdiom.rawValue {
        case 0:
            ConfigurationScrollView().iphoneDevice(self, teams: self.teams)
            break
        case 1:
            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                ConfigurationScrollView().ipadDeviceLandscape(self, teams: self.teams)
            } else {
                ConfigurationScrollView().ipadDevicePortrait(self, teams: self.teams)
            }
            break
        default:
            break
        }
        
    }
    
}

