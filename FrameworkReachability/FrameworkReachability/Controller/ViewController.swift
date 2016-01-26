//
//  ViewController.swift
//  FrameworkReachability
//
//  Created by Ing. Richard José David González on 20/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Controller in charge of administering the view to be shown if the device has Internet access.
*/
class ViewController: UIViewController {

    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkForReachability()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods: Self.
    
    ///Function that determines whether the device has Internet access.
    func checkForReachability() {
        
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let remoteHostStatus: NetworkStatus = reachability.currentReachabilityStatus()
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController?
        
        if remoteHostStatus.rawValue == NotReachable.rawValue {
            
            let windowAppDelegate: UIWindow = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
            
            viewController = mainStoryBoard.instantiateViewControllerWithIdentifier("OffLineViewController")
            
            windowAppDelegate.rootViewController = viewController
            windowAppDelegate.makeKeyAndVisible()
            
        }
        
    }

}

