//
//  ColorToolCommand.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


class ColorToolCommand: Command {
    
    override func run(argv: ARGV) {
        if argv.arguments.count == 0 {
            fail("Need an input file (.scl)")
        }
        
        let inputURL = URLFromArguments(argv)!
        let colors = createColorList(inputURL.absoluteURL!)
        run(colors, inputURL: inputURL, argv: argv)
    }
    
    func run(colors: ColorList, inputURL: NSURL, argv: ARGV) {
    }
    
    func URLFromArguments(argv: ARGV) -> NSURL? {
        if let file = argv.shift() {
            let url = NSURL(fileURLWithPath: file)
            if (url == nil) {
                fail("\(file) is not a valid file path")
            }
            return url
        } else {
            return nil
        }
    }
    
    private func createColorList(inputURL: NSURL) -> ColorList {
        var error: NSError?
        let colorList = SimpleColorListParser().parseFile(inputURL, error: &error)
        if colorList == nil {
            fail(error?.localizedDescription ?? "Could not create color list for file \(inputURL.path)", exitCode: 1)
        }
        return colorList!
    }
}
