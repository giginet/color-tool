//
//  SCSSConstantsGenerator.swift
//  color-tool
//
//  Created by Markus Gasser on 07.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import AppKit


class SCSSConstantsGenerator: ConstantsGenerator {
    
    private var prefix: String?

    
    // MARK: - Public API
    
    required init(prefix initialPrefix: String?) { prefix = initialPrefix }

    func fileNameFor(colorList: ColorList, inputURL: NSURL) -> String {
        let inputFileName = inputURL.URLByDeletingPathExtension?.lastPathComponent!
        let outputFileName = (colorList.name.isEmpty ? inputFileName : colorList.name)!
        return "\(outputFileName).scss"
    }

    func generate(colorList: ColorList, error: NSErrorPointer) -> NSData? {
        var contents = ""

        contents += "// GENERATED FILE - DO NOT MODIFY\n"
        contents += "\n"
        contents += scssEntries(colorList)

        return contents.dataUsingEncoding(NSUTF8StringEncoding)
    }


    // MARK: - Generator functions

    private func scssEntries(colorList: ColorList) -> String {
        return colorList.colors.reduce("", combine: { (entries, color) -> String in
            return entries + self.scssEntry(color) + "\n"
        })
    }

    private func scssEntry(namedColor: NamedColor) -> String {
        var entry = (self.prefix != nil) ? "$\(self.prefix!)-" : ""
        entry += "\(scssPropertyName(namedColor.name)): \(scssColorDeclaration(namedColor.color));"
        return entry
    }

    private func scssPropertyName(name: String) -> String {
        let disallowedChars = NSCharacterSet.alphanumericCharacterSet().invertedSet
        var components = name.componentsSeparatedByCharactersInSet(disallowedChars)
        let start = (self.prefix != nil) ? "" : "$"
        return start + join("-", components.map { $0.lowercaseString })
    }

    private func scssColorDeclaration(color: NSColor) -> String {
        switch color.colorSpace.colorSpaceModel {
        case .NSRGBColorSpaceModel:
            return color.hexString

        default:
            fail("Unsupported color space: \(color.colorSpaceName)")
            return ""
        }
    }
}
