//
//  Logger.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


struct Log {
    
    static var applicationName: String?
    
    static func error(message: String) {
        self.log("error", message: message)
    }
    
    static func warning(message: String) {
        self.log("warning", message: message)
    }
    
    static func info(message: String) {
        self.log(nil, message: message)
    }
    
    private static func log(severity: String?, message: String) {
        if let name = self.applicationName {
            print("\(name): ")
        }
        if severity != nil {
            print("\(severity!): ")
        }
        println(message)
    }
}