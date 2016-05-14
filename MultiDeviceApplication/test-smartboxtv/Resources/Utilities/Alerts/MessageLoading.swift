//
//  MessageLoading.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit

/**
 Class to create a custom message waiting.
 */
class MessageLoading: UIView {
    
    //MARK: - Objects, variables and constants.
    
    ///Activity indicator.
    var activityIndicator: UIActivityIndicatorView?
    
    ///Label to display message waiting.
    var lblLoading: UILabel?
    
    //MARK: - Functions: UIView.
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configurationView()
        self.configurationActivityIndicator()
        self.configurationLblLoading()
        
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        if (newSuperview == nil) {
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.activityIndicator?.stopAnimating()
            
        } else {
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            self.activityIndicator?.startAnimating()
            
        }
        
    }
    
    //MARK: - Functions: Self.
    
    ///Default Settings view.
    private func configurationView() {
    
        var frame: CGRect = self.frame
        frame.size.height = 100
        frame.size.width = 100
        
        let backgroundImage: UIImageView = UIImageView(frame: frame)
        backgroundImage.image = UIImage(named: "img_bkg_loading")
        
        self.frame = frame
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(backgroundImage)
        self.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin]
        
    }
    
    ///Function to set the activity indicator.
    private func configurationActivityIndicator() {
        
        let activityIndicatorCenter: CGPoint = CGPointMake(self.frame.size.width/2,
            (self.frame.size.height/2) - 10)
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.activityIndicator?.center = activityIndicatorCenter
        
        self.addSubview(self.activityIndicator!)
    
    }
    
    ///Function to set the label that displays the message out.
    private func configurationLblLoading() {
        
        let lblFrame: CGRect = CGRectMake(18, 65, 100-10, 20)
        
        self.lblLoading = UILabel(frame: lblFrame)
        self.lblLoading?.textColor = UIColor.whiteColor()
        self.lblLoading?.textAlignment = NSTextAlignment.Left
        self.lblLoading?.font = UIFont(name: Styles.typeFont, size: Styles.typeFontSize)
        self.lblLoading?.backgroundColor = UIColor.clearColor()
        self.lblLoading?.text = "Cargando..."
        
        self.addSubview(self.lblLoading!)
        
    }
    
}
