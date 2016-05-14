//
//  Functions.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit

/**
 Structure containing functions that can be used throughout the scope of application.
 */
struct Functions {
    
    //MARK: - Objects, Variables and constants.
    
    ///Message waiting.
    static var messageLoading: MessageLoading?

    //MARK: - Functions.
    
    /**
     Function to display message waiting.
     - parameter viewController (UIViewController): Controller that invokes the message.
     - parameter text (String): Text to be displayed.
     */
    static func showWaitingMessage(viewController: UIViewController) {
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).window?.endEditing(true)
        
        if (self.messageLoading == nil) {
            self.messageLoading = MessageLoading()
        }
                
        let viewCenter: CGPoint = CGPointMake(viewController.view.frame.size.width/2,
                                              (viewController.view.frame.size.height/2) - 40)
        
        self.messageLoading?.center = viewCenter
        
        if (self.messageLoading?.superview == nil) {
            viewController.view.addSubview(self.messageLoading!)
        }
        
    }
    
    ///Function to hiden message waiting.
    static func dissmissWaitingMessage() {
        
        if (self.messageLoading != nil && self.messageLoading?.superview != nil) {
            self.messageLoading?.removeFromSuperview()
        }
        
    }
    
    /**
     Function to validate characters.
     - parameter character (String): Validate character.
     - returns: True if a character or backspace. Otherwise it returns false.
     */
    static func isLetter(character: String, range: NSRange) -> Bool {
        
        guard character.isEmpty && range.length > 0 else {
            
            guard let range = character.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) else {
                return false
            }
            
            return true
            
        }
        
        return true
        
    }
    
    /**
     Function to download image and display it in a ImageView.
     - parameter imageView (UIImageView): Component where the image is displayed.
     - parameter urlImage (String): URL to download the image.
     */
    static func loadImage(imageView: UIImageView, urlImage: String) {
        
        let url: NSURL = NSURL(string: urlImage)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            guard error == nil else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    imageView.image = UIImage(named: "img_not_found")
                })
                
                return
                
            }
            
            guard (response as! NSHTTPURLResponse).statusCode == 200 else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    imageView.image = UIImage(named: "img_not_found")
                })
                
                return
                
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                imageView.image = UIImage(data: data!)
            })
            
        }
        
        task.resume()
        
    }
    
}
