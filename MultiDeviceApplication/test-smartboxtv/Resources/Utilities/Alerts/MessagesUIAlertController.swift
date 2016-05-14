//
//  MessagesUIAlertController.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit

/**
    Class that contains alert messages.
*/
struct MessagesUIAlertController {
    
    //MARK: - Functions.
    
    /**
     Function to display basic information message.
     - parameter title (String): Message title.
     - parameter message (String): Message to display.
     - returns: Returns an object UIAlertController.
     */
    static func informationMessage(title: String, message: String) -> UIAlertController {
    
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alert: UIAlertAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(alert)
        
        return alertController
        
    }
        
}