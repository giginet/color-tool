//
//  PDFGuideGenerator.swift
//  color-tool
//
//  Created by Markus Gasser on 07.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import Foundation


class PDFGuideGenerator {

    // MARK: - Public API

    func fileNameFor(colorList: ColorList, inputURL: NSURL) -> String {
        let inputFileName = inputURL.URLByDeletingPathExtension?.lastPathComponent!
        let outputFileName = (colorList.name.isEmpty ? inputFileName : colorList.name)!
        return "\(outputFileName).pdf"
    }

    func generate(colorList: ColorList, error: NSErrorPointer) -> NSData? {
        // setup the pdf generation context
        let outputData = NSMutableData()
        let dataConsumer = CGDataConsumerCreateWithCFData(outputData)
        let attributes = [ kCGPDFContextTitle as String: colorList.name ]
        let pdfContext = CGPDFContextCreate(dataConsumer, nil, attributes)

        CGPDFContextBeginPage(pdfContext, nil)
        // draw stuff
        CGPDFContextEndPage(pdfContext)
        CGPDFContextClose(pdfContext)

        return outputData
    }
}
