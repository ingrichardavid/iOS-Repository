//
//  ExtensionUISearchController.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

import UIKit

extension UISearchController {

    var omDBSearchStyle: UISearchController {
        let uiSearchController: UISearchController = UISearchController(searchResultsController: nil)
        uiSearchController.searchBar.tintColor = UIColor.orange
        uiSearchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        uiSearchController.hidesNavigationBarDuringPresentation = false
        uiSearchController.dimsBackgroundDuringPresentation = false
        uiSearchController.searchBar.showsCancelButton = false
        uiSearchController.searchBar.autoresizingMask = [UIViewAutoresizing.flexibleWidth,
                                                         UIViewAutoresizing.flexibleHeight]
        uiSearchController.searchBar.sizeToFit()
        
        return uiSearchController
    }

}
