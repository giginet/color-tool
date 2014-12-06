//
//  Color.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


struct ColorList: Printable {
    
    let name: String
    let colors: [Color]
    
    var description: String {
        return "<ColorList name='\(name)' colors=\(colors)>"
    }
}


struct Color: Printable {
    
    let name: String
    let hexValue: String
    
    var description: String {
        return "<Color name='\(name)' hexValue=#\(hexValue)>"
    }
}
