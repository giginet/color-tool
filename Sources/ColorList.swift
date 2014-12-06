//
//  Color.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import AppKit


struct ColorList: Printable {
    
    let name: String
    let colors: [NamedColor]
    
    var description: String {
        return "<ColorList name='\(name)' colors=\(colors)>"
    }
}


struct NamedColor: Printable {
    
    let name: String
    let color: NSColor
    
    var description: String {
        return "<Color name='\(name)' color=\(color)>"
    }
}
