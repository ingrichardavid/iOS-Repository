//
//  BlogItems.swift
//  BlogReader
//
//  Created by Ing. Richard José David González on 26/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

/**
    Class to manage BlogItems entity in Core Data.
*/
class BlogItems {
    
    //MARK: - Objects, Variables and Constants.
    
    var title: String?
    var content: String?
    
    //MARK: - Initializers.
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
}