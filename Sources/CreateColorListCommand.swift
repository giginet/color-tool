//
//  CreateColorListCommand.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation
import AppKit


class CreateColorListCommand: Command {
    
    init() {
        super.init("create-clr", "Create a color list file")
    }
    
    override func run(argv: ARGV) {
        if argv.arguments.count == 0 {
            fail("Need a file argument")
        } else if argv.arguments.count > 1 {
            fail("Too many arguments passed")
        }
        
        let inputURL = inputURLFromArguments(argv)
        let outputURL = inputURL.URLByDeletingPathExtension!.URLByAppendingPathExtension("clr")
        
        createColorList(inputURL.absoluteURL!, outputURL: outputURL.absoluteURL!)
    }
    
    private func inputURLFromArguments(argv: ARGV) -> NSURL {
        let file = argv.shift()!
        let url = NSURL(fileURLWithPath: file)
        if (url == nil) {
            fail("\(file) is not a valid file path")
        }
        return url!
    }
    
    private func createColorList(inputURL: NSURL, outputURL: NSURL) {
        var error: NSError?
        if let colorList = SimpleColorListParser().parseFile(inputURL, error: &error) {
            writeColorList(colorList, toFileAtURL: outputURL)
        } else {
            fail(error?.localizedDescription ?? "Could not create color list for file \(inputURL.path)", exitCode: 1)
        }
    }
    
    private func writeColorList(colorList: ColorList, toFileAtURL outputURL: NSURL) {
        var clr = NSColorList(name: colorList.name)
        for color in colorList.colors {
            clr.insertColor(color.color, key: color.name, atIndex: clr.allKeys.count)
        }
        clr.writeToFile(outputURL.path!)
    }
}
