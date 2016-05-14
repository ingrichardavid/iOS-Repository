//
//  DataStructureServices.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import Foundation

/**
 Contains the data structure returned by the services.
 */
struct DataStructureServices {
    
    //MARK: Entity Team.
    
    enum EntityTeam: String {
        case entity_name    = "equipo"
        case country        = "inicialespais"
        case name           = "nombre"
        case code           = "id"
        case code_name      = "nombreclave"
        case position       = "posicion"
        case region         = "zona"
        case shield         = "escudo"
    }
    
    //MARK: Entity Result.
    
    enum EntityResult:  String {
        case entity_name        = "result"
        case lost               = "perdidos"
        case dead_heat          = "empatados"
        case played             = "jugados"
        case winner             = "ganados"
        case goal_difference    = "difgol"
        case points             = "puntos"
    }
    
}