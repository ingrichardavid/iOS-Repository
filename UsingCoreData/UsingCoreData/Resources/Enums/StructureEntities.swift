//
//  StructureEntities.swift
//  UsingCoreData
//
//  Created by Ing. Richard José David González on 6/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

/**
    Structure containing enum class to store the structure of the entities created CoreData.
*/
struct StructureEntities {
    
    //MARK: - Structure of the USER_DATA entity.
    
    /**
        Structure of the USER_DATA entity.
        - nameEntity: Entity name.
        - name: Username.
        - address: User address.
        - phone: Phone user.
    */
    enum user_data: String {
    
        case nameEntity     =   "USER_DATA"
        case name           =   "name"
        case address        =   "address"
        case phone          =   "phone"
    
    }
    
}
