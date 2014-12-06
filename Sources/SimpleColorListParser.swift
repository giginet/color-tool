//
//  SimpleColorListParser.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


class SimpleColorListParser: BaseColorListParser {
    
    override func parseFile(contents: NSData, url: NSURL, error: NSErrorPointer) -> ColorList? {
        if let stringContent = NSString(data: contents, encoding: NSUTF8StringEncoding) {
            return parseFile(stringContent, url: url, error: error)
        } else {
            return nil
        }
    }
    
    private func parseFile(contents: String, url: NSURL, error: NSErrorPointer) -> ColorList? {
        let lines = contents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        let colors = lines.map({ self.colorFromSimpleColorEntry($0) }).filter({ $0 != nil }).map({ $0! })
        let fileName = url.lastPathComponent?.stringByDeletingPathExtension
        
        return ColorList(name: fileName ?? "", colors: colors)
    }
    
    private func colorFromSimpleColorEntry(entry: String) -> Color? {
        let blankEntry = entry.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if entry.isEmpty || entry.hasPrefix("#") {
            return nil // blank line or comment
        } else if countElements(entry) < 8 {
            Log.warning("ignoring invalid entry: \(entry)")
            return nil // illegal entry (6 hex + 1 separator + min 1 name char)
        }
        
        let separatorIndex = advance(entry.startIndex, 6)
        if entry[separatorIndex] != ":" {
            return nil // Illegal entry or whitespace
        }
        
        let color = entry.substringToIndex(separatorIndex)
        let name = entry.substringFromIndex(advance(separatorIndex, 1))
            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return Color(name: name, hexValue: color)
    }
}
