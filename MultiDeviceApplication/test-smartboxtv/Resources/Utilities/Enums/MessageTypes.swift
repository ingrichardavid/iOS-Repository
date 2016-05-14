//
//  MessageTypes.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 11/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

/**
 Class containing the types of messages that can be issued by the application.
 - INFORMATION: Information message.
 - WARNING: Warning message.
 - ERROR:  Error message.
 - CONFIRMATION:  Confirmation message.
 */
enum MessageTypes: String {
    case INFORMATION    = "Información"
    case WARNING        = "Aviso"
    case ERROR          = "Error"
    case CONFIRMATION   = "Confirmación"
}