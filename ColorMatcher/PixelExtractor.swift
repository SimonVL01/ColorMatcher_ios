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
    
    //
    
    func getPixelColorAtPoint(point: CGPoint, sourceView: UIView) -> UIColor {
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        sourceView.layer.render(in: context!)
        let color: UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                     green: CGFloat(pixel[1])/255.0,
                                     blue: CGFloat(pixel[2])/255.0,
                                     alpha: CGFloat(pixel[3])/255.0)
        print(color)
        
        pixel.deallocate(capacity: 4)
        return color
    }
    
}
