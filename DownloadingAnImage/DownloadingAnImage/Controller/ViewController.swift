//
//  ViewController.swift
//  DownloadingAnImage
//
//  Created by Ing. Richard José David González on 19/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Class that contains the methods necessary to manage responsible view showing the image downloaded from the web. Implements UIViewController.
*/
class ViewController: UIViewController {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function for restart of fields.
    @IBAction func cleanAll(sender: AnyObject) {
        
        self.txtUrl.text = ""
        self.imageView.image = nil
        
    }
    
    ///Function to show image.
    @IBAction func searchImage(sender: UIButton) {
        
        guard self.txtUrl.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty == false else {
            
            self.presentViewController(self.informationMessage("Please enter the URL!"), animated: true, completion: nil)
            
            return
            
        }
        
        let url: String = self.txtUrl.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        self.downloadImage(url)
        
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
    
    //MARK: - Methods: Self.

    ///Function to download image.
    private func downloadImage(urlImage: String) {
        
        var documentsDirectory: String?
        var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if paths.count > 0 {
            
            guard self.txtUrl.text!.characters.contains("/") == true else {
            
                self.presentViewController(self.informationMessage("URL invalid!"), animated: true, completion: nil)
                return
            
            }
            
            self.imageView.image = nil
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            
            documentsDirectory = paths[0] as? String
            
            let savePath = documentsDirectory! + self.txtUrl.text!.substringFromIndex((self.txtUrl.text?.characters.reverse().indexOf("/")?.successor().base)!)
            
            guard NSFileManager.defaultManager().fileExistsAtPath(savePath) == false else {
                
                self.imageView.image = UIImage(named: savePath)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                return
            
            }
            
            //FIXME: Prevent the image path not allowed to accept special characters in URLs. Example: >, º.
            
            let url: NSURL = NSURL(string: urlImage)!
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                guard error == nil else {
                    
                    print("Error: \(error)")
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                    return
                    
                }
                
                NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.imageView.image = UIImage(named: savePath)
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                    
                })
                
                
            }
            
            task.resume()
            
        }
        
    }
    
    ///Basic function to issue an information message.
    private func informationMessage(message: String) -> UIAlertController {
    
        let alertController: UIAlertController = UIAlertController(title: "Information message.", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let actionAccept: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Cancel,handler: nil)
        
        alertController.addAction(actionAccept)
        
        return alertController
    
    }
    
}

