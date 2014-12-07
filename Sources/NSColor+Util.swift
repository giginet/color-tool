//
//  NSColor+Hex.swift
//  color-tool
//
//  Created by Markus Gasser on 06.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import AppKit


extension NSColor {
    
    class func fromRGBAString(rgba: String) -> NSColor? {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let index   = advance(rgba.startIndex, (rgba.hasPrefix("#") ? 1 : 0))
        let hex     = rgba.substringFromIndex(index)
        let scanner = NSScanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexLongLong(&hexValue) {
            if countElements(hex) == 6 {
                red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                blue  = CGFloat(hexValue & 0x0000FF) / 255.0
            } else if countElements(hex) == 8 {
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            } else {
                return nil
            }
        } else {
            return nil
        }
        
        return NSColor(deviceRed:red, green:green, blue:blue, alpha:alpha)
    }

    func darkerColor() -> NSColor {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0

        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        b *= 0.75
        return NSColor(deviceHue: h, saturation: s, brightness: b, alpha: a)
    }
}
