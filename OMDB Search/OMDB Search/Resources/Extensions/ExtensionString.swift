//
//  ExtensionString.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

extension String {
    
    var localized: String {
        return NSLocalizedString(self,
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "",
                                 comment: "")
    }
    
    var placeholderImageName: String {
        return "img_not_available"
    }
    
}
