//
//  CreateConstantsCommand.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import AppKit


class CreateConstantsCommand: ColorToolCommand {
    
    init() {
        super.init("create-consts", "Create a color constants source file")
    }
    
    override func run(colors: ColorList, inputURL: NSURL, argv: ARGV) {
        if argv.arguments.count > 1 {
            fail("Too many arguments passed")
        }
        
        let outputDirectoryURL = URLFromArguments(argv) ?? inputURL.URLByDeletingLastPathComponent!
        writeSwiftConstants(colors, outputDirectoryURL: outputDirectoryURL)
    }
    
    private func writeSwiftConstants(colors: ColorList, outputDirectoryURL: NSURL) {
        var contents = ""
        
        contents += "// GENERATED FILE - DO NOT MODIFY\n"
        contents += "\n"
        contents += "struct \(swiftClassName(colors.name)) {\n"
        contents += "\n"
        contents += swiftEntries(colors)
        contents += "}\n"
        
        var error: NSError?
        let fileURL = outputDirectoryURL.URLByAppendingPathComponent("\(swiftClassName(colors.name)).swift")
        
        if !contents.writeToURL(fileURL, atomically: true, encoding: NSUTF8StringEncoding, error: &error) {
            fail(error?.localizedDescription ?? "Could not write constants file", exitCode: 1)
        }
    }
    
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
