//
//  Functions.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

import UIKit

struct Functions {

    private static var viewLoading: UIActivityIndicatorView = UIActivityIndicatorView().omDBSearchStyle
    private static var uiWindowView: UIView! = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!.view!
    
    static func showActivityIndicatorView(uiParamView: UIView?) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        viewLoading.startAnimating()

        uiWindowView = uiParamView ?? uiWindowView
        uiWindowView.addSubview(viewLoading)
        uiWindowView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: ["view":viewLoading]))
        uiWindowView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: ["view":viewLoading]))
    }
    
    static func dissmissActivityIndicatorView() {
        viewLoading.stopAnimating()
        viewLoading.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    static func informationMessage(uiViewController: UIViewController!, message: String!) {
        let alertController: UIAlertController = UIAlertController(title: "Alert",
                                                                   message: message,
                                                                   preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: UIAlertActionStyle.cancel,
                                                handler: nil))
        
        if uiViewController.presentedViewController != nil {
            uiViewController.dismiss(animated: false, completion: nil)
        }
        
        uiViewController.present(alertController,
                                 animated: true,
                                 completion: nil)
    }
    
}
