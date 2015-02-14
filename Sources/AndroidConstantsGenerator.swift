//
//  AndroidConstantsGenerator.swift
//  color-tool
//
//  Created by Christoph Lipp on 14/02/15.
//  Copyright (c) 2015 konoma GmbH. All rights reserved.
//

import Foundation
import AppKit


class AndroidConstantsGenerator: ConstantsGenerator {
    
    private var prefix: String?
    
    
    // MARK: - Public API
    
    required init(prefix initialPrefix: String?) { prefix = initialPrefix }
    
    func fileNameFor(colorList: ColorList, inputURL: NSURL) -> String {
        let inputFileName = inputURL.URLByDeletingPathExtension?.lastPathComponent!
        let outputFileName = "colors"
        return "\(outputFileName).xml"
    }
    
    func generate(colorList: ColorList, error: NSErrorPointer) -> NSData? {
        var contents = ""
        
        contents += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        contents += "<resources>\n"
        contents += androidEntries(colorList)
        contents += "</resources>\n"
        
        return contents.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    
    // MARK: - Generator functions
    
    private func androidEntries(colorList: ColorList) -> String {
        return colorList.colors.reduce("", combine: { (entries, color) -> String in
            return entries + "    \(self.androidEntry(color))\n"
        })
    }
    
    private func androidEntry(namedColor: NamedColor) -> String {
        let start = (self.prefix != nil) ? "\(self.prefix!)_" : ""
        return "<color name=\"\(start)\(androidPropertyName(namedColor.name))\">\(namedColor.color.hexString)</color>"
    }
    
    private func androidPropertyName(name: String) -> String {
        var components = (name.componentsSeparatedByString(" ") as Array<String>).map { $0.lowercaseString }
        return "_".join(components)
    }
    
}
