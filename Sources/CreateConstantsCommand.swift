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
        super.init("create-constants", "Create a color constants source file")
    }
    
    override func run(colors: ColorList, inputURL: NSURL, argv: ARGV) {
        if argv.arguments.count > 1 {
            fail("Too many arguments passed")
        }

        let format = argv.option("format")
        let generator = generatorForFormat(format ?? "swift", prefix: argv.option("prefix"))
        if generator == nil {
            let none = "none"
            fail("Unknown constants format: \(format ?? none)")
        }

        let outputDirectoryURL = URLFromArguments(argv) ?? inputURL.URLByDeletingLastPathComponent!
        writeConstants(colors, withGenerator: generator!, inputFileURL: inputURL, outputDirectoryURL: outputDirectoryURL)
    }
    
    private func writeConstants(colors: ColorList, withGenerator generator: ConstantsGenerator, inputFileURL: NSURL, outputDirectoryURL: NSURL) {
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
