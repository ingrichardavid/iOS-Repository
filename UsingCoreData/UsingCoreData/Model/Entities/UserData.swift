//
//  UserData.swift
//  UsingCoreData
//
//  Created by Ing. Richard José David González on 6/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

/**
    This class represents the entity USER_DATA stored in the Core Data. It serves as a template to manage data stored in the entity.
*/
import CoreData

class UserData {
    
    //MARK: - Objects, Variables and Constants.
    
    ///Username.
    var name: String?
    
    ///User address.
    var address: String?
    
    ///Phone user.
    var phone: String?
    
    //MARK: - Initializers
    
    ///Initializer empty.
    init() {}
    
    ///Receiving an object for each field.
    init(name: String, address: String, phone: String) {
        
        self.name = name
        self.address = address
        self.phone = phone
        
    }
    
    ///Receiving a NSManagedObject initializer containing the data of each field of the entity.
    init(object: NSManagedObject) {
    
        self.name = String(object.valueForKey(StructureEntities.user_data.name.rawValue)!)
        self.address = String(object.valueForKey(StructureEntities.user_data.address.rawValue)!)
        self.phone = String(object.valueForKey(StructureEntities.user_data.phone.rawValue)!)
    
    }
    
}