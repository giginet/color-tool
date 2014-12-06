//
//  CreateColorListCommand.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation
import AppKit


class CreateColorListCommand: ColorToolCommand {
    
    init() {
        super.init("create-clr", "Create a color list file")
    }
    
    override func run(colors: ColorList, inputURL: NSURL, argv: ARGV) {
        if argv.arguments.count > 1 {
            fail("Too many arguments passed")
        }
        
        let outputURL = URLFromArguments(argv) ?? defaultURLFromURL(inputURL)
        writeColorList(colors, toFileAtURL: outputURL)
    }
    
    private func writeColorList(colorList: ColorList, toFileAtURL outputURL: NSURL) {
        var clr = NSColorList(name: colorList.name)
        for color in colorList.colors {
            clr.insertColor(color.color, key: color.name, atIndex: clr.allKeys.count)
        }
        clr.writeToFile(outputURL.path!)
    }
    
    private func defaultURLFromURL(url: NSURL) -> NSURL {
        return url.URLByDeletingPathExtension!.URLByAppendingPathExtension("clr")
    }
}
