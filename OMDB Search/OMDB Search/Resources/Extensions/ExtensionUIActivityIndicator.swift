//
//  ExtensionUIActivityIndicator.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    var omDBSearchStyle: UIActivityIndicatorView {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.backgroundColor = UIColor.white
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.orange
        activityIndicator.hidesWhenStopped = true
        activityIndicator.alpha = 0.7
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }

}
