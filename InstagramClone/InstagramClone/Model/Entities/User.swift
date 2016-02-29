//
//  User.swift
//  InstagramClone
//
//  Created by Ing. Richard José David González on 3/2/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

/**
    Entity to represent the class user stored in Parse.
*/
class  User {
    
    //MARK: - Objects, Variables, Constants.

    var username: String?
    var password: String?
    
    //MARK: - Initializers.
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
}