//
//  CreateConstantsCommand.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


class CreateConstantsCommand: ColorToolCommand {
    
    init() {
        super.init("create-consts", "Create a color constants source file")
    }
    
    override func run(colors: ColorList, inputURL: NSURL, argv: ARGV) {
        if argv.arguments.count > 1 {
            fail("Too many arguments passed")
        }
        
        let outputDirectoryURL = URLFromArguments(argv) ?? inputURL.URLByDeletingLastPathComponent!
        writeSwiftConstants(colors, inputFileURL: inputURL, outputDirectoryURL: outputDirectoryURL)
    }
    
    private func writeSwiftConstants(colors: ColorList, inputFileURL: NSURL, outputDirectoryURL: NSURL) {
        let generator = SwiftConstantsGenerator()
        let fileURL = outputDirectoryURL.URLByAppendingPathComponent(generator.fileNameFor(colors, inputURL: inputFileURL))

        var error: NSError?
        if let contents = generator.generate(colors, error: &error) {
            if !contents.writeToURL(fileURL, options: nil, error: &error) {
                failWriting(error)
            }
        } else {
            failWriting(error)
        }
    }

    private func failWriting(error: NSError?) {
        fail(error?.localizedDescription ?? "Could not write constants file", exitCode: 1)
    }
}
