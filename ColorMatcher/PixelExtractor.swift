//
//  PixelExtractor.swift
//  ColorMatcher
//
//  Created by vdab cursist on 24/10/2017.
//  Copyright © 2017 vdab cursist. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class PixelExtractor: NSObject {
    
    let image: CGImage
    let context: CGContext?
    
    var alpha:CGFloat!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    
    var width:Int {
        get {
            return image.width
        }
    }
    
    var height:Int {
        get {
            return image.height
        }
    }
    
    init(img: CGImage) {
        image = img
        context = PixelExtractor.createBitmapContext(img: img)
    }
    
    class func createBitmapContext(img: CGImage) -> CGContext {
        let pixelsWide = img.width
        let pixelsHigh = img.height
        
        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let size = CGSize(width: pixelsWide, height: pixelsHigh)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8,
                                bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let rect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)
        context?.draw(img, in: rect)
        
        return context!
    }
    
    func colorAt(x: Int, y: Int) -> UIColor {
        assert(0<=x && y<width)
        assert(0<=y && y<height)
        
        let data = context!.data
        
        let offset = 4 * (y * width + x)
        alpha = CGFloat((data?.load(fromByteOffset: offset, as: UInt8.self))!)
        red = CGFloat((data?.load(fromByteOffset: offset+1, as: UInt8.self))!)
        green = CGFloat((data?.load(fromByteOffset: offset+2, as: UInt8.self))!)
        blue = CGFloat((data?.load(fromByteOffset: offset+3, as: UInt8.self))!)
        
        let color = UIColor(red: (red / 255), green: (green / 255), blue: (blue / 255), alpha: (alpha / 255))
        
        return color
    }
}
