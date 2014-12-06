//
//  ColorListParser.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


protocol ColorListParser {
    
    func parseFile(URL: NSURL, error: NSErrorPointer) -> ColorList?
}


class BaseColorListParser: ColorListParser {
    
    func parseFile(url: NSURL, error: NSErrorPointer) -> ColorList? {
        if let contents = NSData(contentsOfURL: url, options: nil, error: error) {
            return parseFile(contents, url: url, error: error)
        } else {
            return nil
        }
    }
    
    func parseFile(contents: NSData, url: NSURL, error: NSErrorPointer) -> ColorList? {
        return nil
    }
}
