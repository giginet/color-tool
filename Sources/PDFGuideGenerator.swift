//
//  PDFGuideGenerator.swift
//  color-tool
//
//  Created by Markus Gasser on 07.12.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

import AppKit


class PDFGuideGenerator {

    private let pageBounds = CGRect(x: 0.0, y: 0.0, width: 1024.0, height: 768.0)
    private let headerBounds = CGRect(x: 30.0, y: 638.0, width: 964.0, height: 100.0)
    private let contentBounds = CGRect(x: 30.0, y: 30.0, width: 964.0, height: 608.0)
    private let entrySize = CGSize(width: 110.0, height: 160.0)
    private let entrySpacing = CGSize(width: 10.0, height: 50.0)

    private let titleColor = NSColor(deviceRed:46/255.0, green:73/255.0, blue:156/255.0, alpha:255/255.0)
    private let textColor = NSColor(deviceRed:43/255.0, green:43/255.0, blue:43/255.0, alpha:255/255.0)
    private let lightTextColor = NSColor(deviceRed:189/255.0, green:198/255.0, blue:204/255.0, alpha:255/255.0)

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
        var mediaBox = self.pageBounds
        let pdfContext = CGPDFContextCreate(dataConsumer, &mediaBox, attributes)

        let graphicsContext = NSGraphicsContext(CGContext: pdfContext, flipped: false)
        NSGraphicsContext.setCurrentContext(graphicsContext)

        CGPDFContextBeginPage(pdfContext, nil)
        writeColorList(colorList, toContext: graphicsContext)
        CGPDFContextEndPage(pdfContext)
        CGPDFContextClose(pdfContext)

        return outputData
    }


    // MARK: - Generation functions
    private func writeColorList(colorList: ColorList, toContext context: NSGraphicsContext) {
        let title = colorList.name.uppercaseString as NSString
        let titlePosition = CGPoint(x: self.headerBounds.minX, y: self.headerBounds.maxY - 20.0)
        self.drawText(title, atPoint: titlePosition, fontSize: 36.0, color: self.titleColor)

        var origin = CGPoint(x: self.contentBounds.minX, y: (self.contentBounds.maxY - self.entrySize.height))
        for entry in colorList.colors {
            drawEntry(entry, inContext:context, rect: CGRect(origin: origin, size: self.entrySize))
            origin = self.advanceEntryOrigin(origin)
        }
    }

    private func drawEntry(entry: NamedColor, inContext context: NSGraphicsContext, rect: CGRect) {
        let partHeight = (rect.height / 3.0)

        // draw the color below
        let colorBlobHeight = partHeight + 10.0
        let colorBlobRect = CGRect(x: rect.minX - 1.0, y: rect.maxY - colorBlobHeight, width: rect.width + 2.0, height: colorBlobHeight)
        entry.color.setFill()
        CGContextFillRect(context.CGContext, colorBlobRect)

        entry.color.darkerColor().setStroke()
        CGContextStrokeRect(context.CGContext, colorBlobRect)

        // draw the name
        let name = entry.name.uppercaseString as NSString
        self.drawText(name, atPoint: CGPoint(x: rect.minX, y: (rect.minY + partHeight + 10.0)), fontSize: 10.0, color: self.textColor)

        // draw the separator
        let separatorRect = CGRect(x: rect.minX, y: (rect.minY + partHeight), width: rect.width, height: 0.5)
        self.lightTextColor.setFill()
        CGContextFillRect(context.CGContext, separatorRect)

        // draw the hex rgb value
        let hexY = (rect.minY + (partHeight / 3.0))
        self.drawText("hex", atPoint: CGPoint(x: rect.minX, y: hexY + 1.0), fontSize: 8.0, color: self.lightTextColor)
        self.drawText(entry.color.hexString, atPoint: CGPoint(x: (rect.minX + 20.0), y: hexY), fontSize: 10.0, color: self.textColor)

        // draw the decimal rgb value
        let rgbY = rect.minY
        self.drawText("rgb", atPoint: CGPoint(x: rect.minX, y: rgbY + 1.0), fontSize: 8.0, color: self.lightTextColor)
        self.drawText(self.rgbStringForColor(entry.color), atPoint: CGPoint(x: (rect.minX + 20.0), y: rgbY), fontSize: 10.0, color: self.textColor)
    }

    private func drawText(text: NSString, atPoint point: CGPoint, fontSize: CGFloat, color: NSColor) {
        let attributes = [
            NSFontAttributeName: self.font(fontSize),
            NSForegroundColorAttributeName: color
        ]
        text.drawAtPoint(point, withAttributes: attributes)
    }

    private func font(size: CGFloat) -> NSFont {
        return NSFont(name: "CentraleSansLight", size: size) ?? NSFont.systemFontOfSize(size)
    }

    private func advanceEntryOrigin(origin: CGPoint) -> CGPoint {
        var newOrigin = origin

        // advance one to the right
        newOrigin.x += self.entrySize.width + self.entrySpacing.width
        if newOrigin.x + self.entrySize.width < self.contentBounds.maxX {
            return newOrigin
        }

        // wrap line
        newOrigin.x = self.contentBounds.minX
        newOrigin.y -= (self.entrySize.height + self.entrySpacing.height)
        if newOrigin.y > self.contentBounds.minY {
            return newOrigin
        }

        // wrap page
        let pdfContext = NSGraphicsContext.currentContext()!.CGContext
        CGPDFContextEndPage(pdfContext)
        CGPDFContextBeginPage(pdfContext, nil)
        return CGPoint(x: self.contentBounds.minX, y: (self.contentBounds.maxY - self.entrySize.height))
    }

    private func rgbStringForColor(color: NSColor) -> String {
        return NSString(format: "%d / %d / %d", Int(color.redComponent * 255.0), Int(color.greenComponent * 255.0), Int(color.blueComponent * 255.0))
    }
}
