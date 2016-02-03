//
//  ViewController.swift
//  GettingImagesFromLibraryAndCamera
//
//  Created by Ing. Richard José David González on 2/2/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Controller for loading images. Implements: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate.
*/
class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Objects, Variables and constants.
    @IBOutlet weak var importedImage: UIImageView!
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Method to import pictures from the device library.
    @IBAction func importImage(sender: UIBarButtonItem) {
        
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.allowsEditing = false
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Methods: UIImagePickerControllerDelegate.
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.importedImage.image = image
        
    }

}

