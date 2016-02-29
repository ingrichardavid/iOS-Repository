/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

/**
    ViewController responsible for managing register, edit, delete and find products. Implements UIViewController.
*/
class ViewController: UIViewController{
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblRegistered: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    //MARK: - Objects, Variables and Constants
    
    ///It indicates whether an account is active.
    var signUpActive: Bool = true
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to register a new user.
    @IBAction func signUp(sender: UIButton) {
        
        guard self.validateFields() == true else {
            return
        }
        
        let user: User = User(username: self.txtUserName.text!, password: self.txtPassword.text!)
        
        self.configurationActivityIndicator(true)
        self.insertOrLoginUser(user)
        
    }
    
    ///Function to login.
    @IBAction func logIn(sender: UIButton) {
        
        guard self.signUpActive == false else {
        
            self.btnSignUp.setTitle("SignUp", forState: UIControlState.Normal)
            self.lblRegistered.text = "Already registered?"
            self.btnLogin.setTitle("LogIn", forState: UIControlState.Normal)
            self.signUpActive = false
            return
        
        }        
        
        self.btnSignUp.setTitle("LogIn", forState: UIControlState.Normal)
        self.lblRegistered.text = "Not registered?"
        self.btnLogin.setTitle("SignUp", forState: UIControlState.Normal)
        self.signUpActive = true
        
    }
    
    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {

        guard PFUser.currentUser()?.objectId == nil else {
            
            self.performSegueWithIdentifier("login", sender: self)
            return
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods: Self.
    
    ///Function to validate that the required fields are completed.
    private func validateFields() -> Bool {
        
        guard self.txtUserName.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false else {
            
            self.txtUserName.becomeFirstResponder()
            self.presentViewController(self.informationMessage("Error in form", message: "Please enter a username!"), animated: true, completion: nil)
            
            return false
            
        }
        
        guard self.txtPassword.text?.isEmpty == false else {
            
            self.txtPassword.becomeFirstResponder()
            self.presentViewController(self.informationMessage("Error in form", message: "Please enter a password!"), animated: true, completion: nil)
            
            return false
            
        }
        
        return true
    
    }
    
    ///Function to generate a basic message information.
    private func informationMessage(title: String, message: String) -> UIAlertController {
    
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alertController.addAction(alertAction)
        
        return alertController
    
    }
    
    ///UIActivityIndicator configuration.
    private func configurationActivityIndicator(status: Bool) {
    
        switch (status) {
        
        case true:
            
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            break
            
        case false:
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            break
            
        }
    
    }
    
    ///Function for registration and user authentication.
    private func insertOrLoginUser(user: User) {

        let pfUser: PFUser = PFUser()
        pfUser.username = user.username!
        pfUser.password = user.password!
        
        var errorMessage: String = "Please try again later."
        
        guard self.signUpActive == false else {
        
            PFUser.logInWithUsernameInBackground(user.username!, password: user.password!, block: { (user, error) -> Void in
                
                guard error == nil else {
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if let errorString: String = String(error!.userInfo["error"]!) {
                        errorMessage = errorString
                    }
                    
                    self.presentViewController(self.informationMessage("Failed LogIn!", message: errorMessage), animated: true, completion: nil)
                    
                    return
                
                }
                
                self.txtUserName.text = ""
                self.txtUserName.becomeFirstResponder()
                self.txtPassword.text = ""
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.performSegueWithIdentifier("login", sender: self)
                
            })
        
            return
            
        }
        
        pfUser.signUpInBackgroundWithBlock { (status, error) -> Void in
            
            guard error == nil else {
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if let errorString: String = String(error!.userInfo["error"]!) {
                    errorMessage = errorString
                }
                
                self.presentViewController(self.informationMessage("Failed SignUp!", message: errorMessage), animated: true, completion: nil)
                
                return
                
            }
            
            self.txtUserName.text = ""
            self.txtUserName.becomeFirstResponder()
            self.txtPassword.text = ""
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.performSegueWithIdentifier("login", sender: self)
            
        }
        
    }
    
}
