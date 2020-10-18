//
//  Extension.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/17.
//

import Foundation
import SwiftUI

extension UIImage {
    //UIImage -> [UInt8] (RGB Data)
    func toRGB() -> [UInt8]? {
        guard self.cgImage != nil else {return nil}
        guard self.cgImage!.dataProvider != nil else {return nil}
        let bmp:CFData? = self.cgImage!.dataProvider!.data
        let dataPointer:UnsafePointer<UInt8> = CFDataGetBytePtr(bmp)
        let dataLength:Int = (self.cgImage!.bitsPerPixel / self.cgImage!.bitsPerComponent) * Int(size.width) * Int(size.height)
        var pixelData = Data(bytes: dataPointer, count: dataLength)
        if self.cgImage!.bitsPerPixel == 16 {
            var i = 0
            while i < pixelData.count {
                pixelData.insert(pixelData[i], at: i + 1)
                pixelData.insert(pixelData[i], at: i + 2)
                i += 4
            }
        }
        
        return [UInt8](pixelData)
    }
}

struct Pixel
{
    var Red:   UInt8 = 0
    var Green: UInt8 = 0
    var Blue:  UInt8 = 0
    var Alpha: UInt8 = 0
}

extension Array where Element == UInt8 {
    //[UInt8] (RGB Data) -> UIImage
    func toImage(width: Int, height: Int, colorSpace:CGColorSpace) -> UIImage? {
        var pixelArray: [Pixel] = [Pixel]()
        
        for i in stride(from: 0, to: self.count, by: 4)
        {
            let pixelColor: Pixel = Pixel(Red: self[i], Green: self[i+1], Blue: self[i+2], Alpha: self[i+3])
            pixelArray.append(pixelColor)
        }

        let bitmapCount: Int = pixelArray.count
        let elmentLength: Int = MemoryLayout<Pixel>.size
        let render: CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        let rgbColorSpace = colorSpace
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let providerRef: CGDataProvider? = CGDataProvider(data: NSData(bytes: &pixelArray, length: bitmapCount * elmentLength))
        let cgimage: CGImage? = CGImage(width: width,
                                        height: height,
                                        bitsPerComponent: 8,
                                        bitsPerPixel: 32,
                                        bytesPerRow: width * elmentLength,
                                        space: rgbColorSpace,
                                        bitmapInfo: bitmapInfo,
                                        provider: providerRef!,
                                        decode: nil,
                                        shouldInterpolate: true,
                                        intent: render)
        guard cgimage != nil else {return nil}
        return UIImage(cgImage: cgimage!)
    }
}
