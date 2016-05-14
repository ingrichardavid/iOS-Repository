//
//  Messages.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import Foundation

/**
 Class that contains the messages to be issued by the application.
 */
struct Messages {
    
    struct Global {
        
        /**
         Error interno del servidor. Intente nuevamente.
        */
        static let INTERNAL_SERVER_ERROR: String = "Error interno del servidor. Intente nuevamente."
    
    }
    
    struct ControllerListTeams {
        
        /**
         No se encontraron equipos.
         */
        static let TEAMS_NOT_FOUND: String = "No se encontraron equipos."
        
    }
    
}
