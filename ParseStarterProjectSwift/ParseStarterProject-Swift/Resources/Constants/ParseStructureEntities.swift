//
//  ParseStructureEntities.swift
//  ParseStarterProject-Swift
//
//  Created by Ing. Richard José David González on 27/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

/**
    Structure of the entities stored in Parse.
*/
struct ParseStructureEntities {
    
    ///Product entity
    enum product: String {
    
        case name_entity = "Product"
        case code = "objectId"
        case name = "name"
        case description = "description"
        case price = "price"
        
    }
    
}