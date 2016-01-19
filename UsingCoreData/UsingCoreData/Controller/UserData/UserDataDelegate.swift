//
//  UserDataProtocol.swift
//  UsingCoreData
//
//  Created by Ing. Richard José David González on 6/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Protocol to be implemented in class UserDataVC.
*/
protocol UserDataDelegate {
    
    //MARK: - Methods.
    
    ///Function to set the initial configuration of objects.
    func configurationInitial()
    
    ///Method to validate that all required fields are completed.
    func validateFields() -> Bool
    
    ///Method for emitting basic information message.
    func informationMessage(message: String, title: String) -> UIAlertController

}
