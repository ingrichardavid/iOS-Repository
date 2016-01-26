//
//  AppDelegate.swift
//  FrameworkReachability
//
//  Created by Ing. Richard José David González on 20/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    ///Object to determine if the device has Internet access.
    var reachability: Reachability?
    
    //MARK: - Methods: Life cycle of the application.

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.configurationReachability()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - Methods: Self.
    
    ///Configuration of object reachability.
    private func configurationReachability() {
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkForReachability:", name: kReachabilityChangedNotification, object: nil)
        self.reachability = Reachability.reachabilityForInternetConnection()
        self.reachability?.startNotifier()
    
    }
    
    ///Function that determines whether the device has Internet access.
    func checkForReachability(notification: NSNotification) {
        
        let remoteHostStatus: NetworkStatus = self.reachability!.currentReachabilityStatus()
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("OnLineViewController")
        
        if remoteHostStatus.rawValue == NotReachable.rawValue {
            viewController = mainStoryBoard.instantiateViewControllerWithIdentifier("OffLineViewController")
        }
        
        self.window!.rootViewController = viewController
        self.window!.makeKeyAndVisible()
        
    }
    
}

