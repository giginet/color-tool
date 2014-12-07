//
//  SwiftConstantsGenerator.swift
//  color-tool
//
//  Created by Markus Gasser on 07.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation
import AppKit


class SwiftConstantsGenerator {

    // MARK: - Public API

    func fileNameFor(colorList: ColorList, inputURL: NSURL) -> String {
        let inputFileName = inputURL.URLByDeletingPathExtension?.lastPathComponent!
        let outputFileName = (colorList.name.isEmpty ? inputFileName : swiftClassName(colorList.name))!
        return "\(outputFileName).swift"
    }

    func generate(colorList: ColorList, error: NSErrorPointer) -> NSData? {
        var contents = ""

        contents += "// GENERATED FILE - DO NOT MODIFY\n"
        contents += "\n"
        contents += "struct \(swiftClassName(colorList.name)) {\n"
        contents += "\n"
        contents += swiftEntries(colorList)
        contents += "}\n"

        return contents.dataUsingEncoding(NSUTF8StringEncoding)
    }


    // MARK: - Generator functions

    private func swiftClassName(name: String) -> String {
        let disallowedChars = NSCharacterSet.alphanumericCharacterSet().invertedSet
        return join("", name.componentsSeparatedByCharactersInSet(disallowedChars).map { $0.capitalizedString })
    }

    private func swiftEntries(colorList: ColorList) -> String {
        return colorList.colors.reduce("", combine: { (entries, color) -> String in
            return entries + "    \(self.swiftEntry(color))\n"
        })
    }

    private func swiftEntry(namedColor: NamedColor) -> String {
        return "static let \(swiftPropertyName(namedColor.name)) = \(swiftColorDeclaration(namedColor.color))"
    }

    private func swiftPropertyName(name: String) -> String {
        let disallowedChars = NSCharacterSet.alphanumericCharacterSet().invertedSet
        var components = name.componentsSeparatedByCharactersInSet(disallowedChars)
        let firstComponent = components.removeAtIndex(0).lowercaseString
        return firstComponent + join("", components.map { $0.capitalizedString })
    }

    private func swiftColorDeclaration(color: NSColor) -> String {
        switch color.colorSpace.colorSpaceModel {
        case .NSRGBColorSpaceModel:
            return "UIColor("
                + "red: \(self.round(color.redComponent)), "
                + "green: \(self.round(color.greenComponent)), "
                + "blue: \(self.round(color.blueComponent)), "
                + "alpha: \(self.round(color.alphaComponent)))"

        default:
            fail("Unsupported color space: \(color.colorSpaceName)")
            return ""
        }
    }

    private func round(component: CGFloat) -> Float {
        return roundf(Float(component) * 100.0) / 100.0
    }
}
