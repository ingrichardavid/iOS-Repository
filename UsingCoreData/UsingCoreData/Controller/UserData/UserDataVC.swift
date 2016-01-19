//
//  ViewController.swift
//  UsingCoreData
//
//  Created by Ing. Richard José David González on 6/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Controller to manage the view responsible for carrying out the registration procedure, modification and deletion of data. Implements UIViewController, UITextFieldDelegate, UserDataDelegate.
*/
class UserDataVC: UIViewController, UITextFieldDelegate, UserDataDelegate {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var barBtnItemAdd: UIBarButtonItem!
    @IBOutlet weak var barBtnItemEdit: UIBarButtonItem!
    @IBOutlet weak var barBtnItemDelete: UIBarButtonItem!
    
    //MARK: - Objects, Variables and constants.
    
    ///Object model to manipulate data USER_DATA entity.
    var userData: UserData?
    
    ///Containing class services to manipulate data in the CoreData USER_DATA entity.
    private var cdUserData: CDUserData = CDUserData()
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to hide the keyboard to touch any part of scrollview.
    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    ///Method to register a user.
    @IBAction func addUser(sender: UIBarButtonItem) {
        
        guard self.validateFields() == true else {
            return
        }
        
        guard self.cdUserData.findUser(self.userData!) as! NSObject == 0 else {
            
            self.presentViewController(self.informationMessage("The user is already registered.", title: "Information message"), animated: true, completion: nil)
            
            return
            
        }
        
        guard self.cdUserData.insert(self.userData!) == true else {
            
            self.presentViewController(self.informationMessage("Failed to register user. Try again!", title: "Error message"), animated: true, completion: nil)
            
            return
            
        }
        
        self.presentViewController(self.informationMessage("Registered user!", title: "Information message"), animated: true, completion: nil)
        self.userData = nil
        self.configurationInitial()
        
    }
    
    ///Method to edit a user.
    @IBAction func editUser(sender: UIBarButtonItem) {
        
        guard self.validateFields() == true else {
            return
        }
        
        guard self.cdUserData.update(self.userData!) == true else {
            
            self.presentViewController(self.informationMessage("Failed to modify user. Try again!", title: "Error message"), animated: true, completion: nil)
            
            return
            
        }
        
        self.presentViewController(self.informationMessage("Modified user!", title: "Information message"), animated: true, completion: nil)
        self.userData = nil
        self.configurationInitial()
        
    }
    
    ///Method to delete a user.
    @IBAction func deleteUser(sender: UIBarButtonItem) {
        
        self.userData = nil
        self.configurationInitial()
        
    }
    
    //MARK: - Methods: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurationInitial()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        guard self.cdUserData.findUsers().count > 0 else {
        
            self.presentViewController(self.informationMessage("No registered user!", title: "Information message"), animated: true, completion: nil)
            
            return false
        
        }
        
        return true
        
    }
    
    //MARK: - Methods: UITextFieldDelegate.
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard textField != self.txtUserName else {
            
            let newString: NSString = (self.txtUserName.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= 50
            
        }
        
        guard textField != self.txtAddress else {
            
            let newString: NSString = (self.txtAddress.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= 100
            
        }
        
        guard textField != self.txtPhone else {
            
            let newString: NSString = (self.txtPhone.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= 20
            
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    //MARK: - Methods: UserDataDelegate
    
    ///Initial view settings.
    func configurationInitial() {
        
        guard self.userData == nil else {
            
            self.txtUserName.text = self.userData?.name
            self.txtAddress.text = self.userData?.address
            self.txtPhone.text = self.userData?.phone
            self.barBtnItemAdd.enabled = false
            self.barBtnItemEdit.enabled = true
            self.txtUserName.enabled = false
            
            return
        
        }
        
        self.barBtnItemAdd.enabled = true
        self.barBtnItemEdit.enabled = false
        self.txtUserName.text = ""
        self.txtUserName.enabled = true
        self.txtAddress.text = ""
        self.txtPhone.text = ""
    
    }
    
    ///Function to validate that the required fields are completed.
    func validateFields() -> Bool {
        
        guard self.txtUserName.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false else {
            
            self.txtUserName.becomeFirstResponder()
            
            return false
            
        }
        
        guard self.txtAddress.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false else {
            
            self.txtAddress.becomeFirstResponder()
            
            return false
            
        }
        
        guard self.txtPhone.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false else {
            
            self.txtPhone.becomeFirstResponder()
            
            return false
            
        }
        
        self.userData = UserData(name: self.txtUserName.text!, address: self.txtAddress.text!, phone: self.txtPhone.text!)
        
        return true
        
    }
    
    ///Function to issue an information message.
    func informationMessage(message: String, title: String) -> UIAlertController {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let accept: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(accept)
        
        return alertController
        
    }
    
}

