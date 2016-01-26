//
//  EntityFreeGeoIp.swift
//  JSONWebExample
//
//  Created by Ing. Richard José David González on 25/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Class to represent the JSON object returned by the Web.
*/
class EntityFreeGeoIp {

    //MARK: - Attributes.
    
    var ip: String?
    var country_code: String?
    var country_name: String?
    var region_code: String?
    var region_name: String?
    var city: String?
    var zip_code: String?
    var time_zone: String?
    var latitude: String?
    var longitude: String?
    var metro_code: String?

    //MARK: - Initializers.
    
    init(anyObject: AnyObject) {
        
        self.ip = String(anyObject["ip"]! as! String)
        self.country_code = String(anyObject["country_code"]! as! String)
        self.country_name = String(anyObject["country_name"]! as! String)
        self.region_code = String(anyObject["region_code"]! as! String)
        self.region_name = String(anyObject["region_name"]! as! String)
        self.city = String(anyObject["city"]! as! String)
        self.zip_code = String(anyObject["zip_code"]! as! String)
        self.time_zone = String(anyObject["time_zone"]! as! String)
        self.latitude =  anyObject["latitude"]!?.stringValue
        self.longitude = anyObject["longitude"]!?.stringValue
        self.metro_code = anyObject["metro_code"]!?.stringValue
        
    }

}