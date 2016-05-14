//
//  Team.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 Entity Team: It represents the teams. Implements NSObject.
 */
class Team: NSObject {
    
    var country: String?
    var name: String?
    var code: Int?
    var code_name: String?
    var position: Int?
    var region: String?
    var shield: String?
    var results: Result?
    
    override init() {}
    
    init(json: JSON) {
        self.country = String(json[DataStructureServices.EntityTeam.country.rawValue])
        self.name = String(json[DataStructureServices.EntityTeam.name.rawValue])
        self.code = Int(String(json[DataStructureServices.EntityTeam.code.rawValue]))
        self.code_name = String(json[DataStructureServices.EntityTeam.code_name.rawValue])
        self.position = Int(String(json[DataStructureServices.EntityTeam.position.rawValue]))
        self.region = String(json[DataStructureServices.EntityTeam.region.rawValue])
        self.shield = String(json[DataStructureServices.EntityTeam.shield.rawValue])
        self.results = Result(json: json[DataStructureServices.EntityResult.entity_name.rawValue])
    }
        
}
