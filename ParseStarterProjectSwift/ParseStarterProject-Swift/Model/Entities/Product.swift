//
//  Product.swift
//  ParseStarterProject-Swift
//
//  Created by Ing. Richard José David González on 27/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Parse

/**
    Entity to represent the class stored in Parse.
*/
class Product {

    //MARK: - Objects, Variables, Constants.
    
    var code: String?
    var name: String?
    var description: String?
    var price: String?
    
    //MARK: - Initializers.
    
    init() {}
    
    init(code: String) {
        self.code = String(code)
    }
    
    init(anyObject: PFObject) {
        self.code = anyObject.objectId
        self.name = String(anyObject.objectForKey(ParseStructureEntities.product.name.rawValue)!)
        self.description = String(anyObject.objectForKey(ParseStructureEntities.product.description.rawValue)!)
        self.price = String(anyObject.objectForKey(ParseStructureEntities.product.price.rawValue)!)
    }
    
    init(code: String, name: String, description: String, price: String) {
        self.code = code
        self.name = name
        self.description = description
        self.price = price
    }
    
    init(name: String, description: String, price: String) {
        self.name = name
        self.description = description
        self.price = price
    }
    
}
