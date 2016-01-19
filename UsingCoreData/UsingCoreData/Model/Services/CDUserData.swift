//
//  CDUserDAta.swift
//  UsingCoreData
//
//  Created by Ing. Richard José David González on 6/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit
import CoreData

/**
    Class that contains the service to interact with the USER_DATA entity stored in the CoreData.
*/
class CDUserData {
    
    //MARK: - Objects, Variables and constants.
    
    ///AppDelegate instance.
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    ///Variable for an instance of the data base CoreData.
    var context: NSManagedObjectContext?
    
    //MARK: - Services.
    
    ///Service to insert data into the entity.
    func insert(userData: UserData) -> Bool {
        
        self.context = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName(StructureEntities.user_data.nameEntity.rawValue, inManagedObjectContext: self.context!)
        
        entity.setValue(userData.name!, forKey: StructureEntities.user_data.name.rawValue)
        entity.setValue(userData.address!, forKey: StructureEntities.user_data.address.rawValue)
        entity.setValue(userData.phone!, forKey: StructureEntities.user_data.phone.rawValue)
        
        do {
            try self.context?.save()
        } catch {
            return false
        }
        
        return true
        
    }
    
    ///Service to update data into the entity.
    func update(userData: UserData) -> Bool {
        
        self.context = appDelegate.managedObjectContext
        
        let entity = self.findUser(userData) as! NSManagedObject
        
        entity.setValue(userData.name!, forKey: StructureEntities.user_data.name.rawValue)
        entity.setValue(userData.address!, forKey: StructureEntities.user_data.address.rawValue)
        entity.setValue(userData.phone!, forKey: StructureEntities.user_data.phone.rawValue)
        
        do {
            try self.context?.save()
        } catch {
            return false
        }
        
        return true
    
    }
    
    ///Service for data service request. Returns an object NSManagedObject.
    func findUser(userData: UserData) -> AnyObject {
        
        self.context = appDelegate.managedObjectContext
        
        var results: [AnyObject]? = nil
        let request = NSFetchRequest(entityName: StructureEntities.user_data.nameEntity.rawValue)
        let predicate = NSPredicate(format: "name == %@", userData.name!)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            
            results = try self.context!.executeFetchRequest(request)
            
            if (results!.count > 0) {
                return results![0]
            }
            
        } catch {
            
            print("Fetch Failed!")
            return 0
            
        }
        
        return 0
        
    }
    
    ///Service for stored data.
    func findUsers() -> [UserData] {
        
        self.context = appDelegate.managedObjectContext
        
        var users = [UserData]()
        var results: [AnyObject]?
        let request = NSFetchRequest(entityName: StructureEntities.user_data.nameEntity.rawValue)
        request.returnsObjectsAsFaults = false
        
        do {
            
            results = try self.context!.executeFetchRequest(request)
            
            if (results!.count > 0) {
                
                for result in results as! [NSManagedObject] {
                    
                    let userData: UserData = UserData(object: result)
                    users.append(userData)
                    
                }
                
            }
            
        } catch {
            
            print("Fetch Failed!")
            return users
            
        }
        
        return users
        
    }
    
    ///Service to delete user.
    func delete(userData: UserData) -> Bool {
        
        self.context = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: StructureEntities.user_data.nameEntity.rawValue)        
        let predicate = NSPredicate(format: "name == %@", userData.name!)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try self.context!.executeFetchRequest(request)
            
            if (results.count > 0) {
                
                for result in results as! [NSManagedObject] {
                    
                    self.context!.deleteObject(result)
                    
                    do {
                        try self.context!.save()
                    } catch {
                        return false
                    }
                    
                }
                
            }
            
        } catch {
            
            print("Fetch Failed!")
            return false
            
        }
        
        return true
        
    }
    
    ///Service to validate that the user does not exist.
    func validateUser(userData: UserData) -> Bool {
        
        self.context = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: StructureEntities.user_data.nameEntity.rawValue)
        let predicate = NSPredicate(format: "%@", userData.name!)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try self.context!.executeFetchRequest(request)
            
            if (results.count > 0) {
                return true
            }
            
        } catch {
            
            print("Fetch Failed!")
            return false
            
        }
        
        return false
    
    }

}