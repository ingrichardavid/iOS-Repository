//
//  PostImageViewController.swift
//  InstagramClone
//
//  Created by Ing. Richard José David González on 5/2/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit
import Parse

/**
    Controller responsible for managing view loading images. Implements UIViewController, UINavigationControllerDelegate and UIImagePickerControllerDelegate.
*/
class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var imgImageToPost: UIImageView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to select image.
    @IBAction func chooseImage(sender: UIButton) {
        
        let image: UIImagePickerController = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    ///Function to publish images
    @IBAction func postImage(sender: UIButton) {
        
        guard self.validateFields() == true else {
            return
        }
        
        self.configurationActivityIndicator(true)
        
        let post: PFObject = PFObject(className: "Post")
        post["message"] = self.txtMessage.text
        post["userId"] = PFUser.currentUser()?.objectId!
        
        let imageData: NSData? = UIImageJPEGRepresentation(self.imgImageToPost.image!, 0.5)
        let imageFile: PFFile = PFFile(name: "image.png", data: imageData!)!
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            guard error == nil else {
            
                print("Failed request!. Error: \(error)")
                return
                
            }
            
            self.configurationActivityIndicator(false)
            self.resetFields()
            
        }
        
    }
    
    //MARK: - Methods: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Methods: UIImagePickerControllerDelegate.
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imgImageToPost.image = image
        
    }
    
    //MARK: - Methods: Self.
    
    ///Function to validate that the required fields are completed.
    private func validateFields() -> Bool {
    
        guard self.txtMessage.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false else {
            
            self.txtMessage.becomeFirstResponder()
            return false
            
        }
        
        return true
    
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
    
    ///Reset fields.
    private func resetFields() {
    
        self.imgImageToPost.image = UIImage(named: "image")
        self.txtMessage.text = ""
    
    }

}
