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
}

func generatorForFormat(format: String) -> ConstantsGenerator? {
    switch format {
    case "swift":
        return SwiftConstantsGenerator()

    case "scss":
        return SCSSConstantsGenerator()

    default:
        return nil
    }
}
