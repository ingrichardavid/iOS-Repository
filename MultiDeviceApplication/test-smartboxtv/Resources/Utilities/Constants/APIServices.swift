//
//  APIServices.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import Foundation

/**
 Structure containing the paths to Web services.
 */
struct APIServices {
    
    /**
     Route to the API.
     */
    static let apiBaseUrl: String = "http://23.21.72.216:8080/Futbol/1.0"
    
    /**
     Service team list.
     - HTTP method: GET.
     - Service parameters:
        - campeonato: Country where is held the championship.
     */
    static let list_of_teams: String = APIServices.apiBaseUrl + "/Posiciones/Lista"
    
}