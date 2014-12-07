//
//  CreateGuideCommand.swift
//  color-tool
//
//  Created by Markus Gasser on 07.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


class CreateGuideCommand: ColorToolCommand {

    init() {
        super.init("create-guide", "Create a color guide as a PDF")
    }

    override func run(colors: ColorList, inputURL: NSURL, argv: ARGV) {
        if argv.arguments.count > 1 {
            fail("Too many arguments passed")
        }

        let outputDirectoryURL = URLFromArguments(argv) ?? inputURL.URLByDeletingLastPathComponent!
        writeGuide(colors, inputFileURL: inputURL, outputDirectoryURL: outputDirectoryURL)
    }

    private func writeGuide(colors: ColorList, inputFileURL: NSURL, outputDirectoryURL: NSURL) {
        let generator = PDFGuideGenerator()
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
