//
//  Result.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 Entity Result: It represents the results of the teams. Implements NSObject.
 */
class Result: NSObject {
    
    var lost: Int?
    var dead_heat: Int?
    var played: Int?
    var winner: Int?
    var goal_difference: Int?
    var points: Int?
    
    override init() {}
    
    init (json: JSON) {
        self.lost = Int(String(json[DataStructureServices.EntityResult.lost.rawValue]))
        self.dead_heat = Int(String(json[DataStructureServices.EntityResult.dead_heat.rawValue]))
        self.played = Int(String(json[DataStructureServices.EntityResult.played.rawValue]))
        self.winner = Int(String(json[DataStructureServices.EntityResult.winner.rawValue]))
        self.goal_difference = Int(String(json[DataStructureServices.EntityResult.goal_difference.rawValue]))
        self.points = Int(String(json[DataStructureServices.EntityResult.points.rawValue]))
    }

}
