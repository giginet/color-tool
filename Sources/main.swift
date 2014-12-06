//
//  main.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


Log.applicationName = Process.arguments[0].lastPathComponent


let fileURL = NSURL(fileURLWithPath: "/Users/alfonso/Development/color-tool/Sources/sample.scl")!
var error: NSError?

if let colorList = SimpleColorListParser().parseFile(fileURL, error: &error) {
    println("Color List: \(colorList)")
} else {
    println("Error: \(error)")
}
