//
//  ConstantsGenerator.swift
//  color-tool
//
//  Created by Markus Gasser on 07.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


protocol ConstantsGenerator {
    func fileNameFor(colorList: ColorList, inputURL: NSURL) -> String
    func generate(colorList: ColorList, error: NSErrorPointer) -> NSData?
    init(prefix: String?)
}

func generatorForFormat(format: String, #prefix: String?) -> ConstantsGenerator? {
    switch format {
    case "swift":
        return SwiftConstantsGenerator(prefix: prefix)

    case "scss":
        return SCSSConstantsGenerator(prefix: prefix)

    case "android":
        return AndroidConstantsGenerator(prefix: prefix)
        
    default:
        return nil
    }
}
