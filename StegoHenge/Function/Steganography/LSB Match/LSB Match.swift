//
//  LSBOriginal.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/18.
//

import Foundation
import SwiftUI

//隱藏：String -> Data? ->  Binary
//拿出：Binary -> Data? -> String

func LSB_Match_Hide(image uiiImg:UIImage?, data strInfo:String) -> UIImage? {
    
    var ui8Img:[UInt8]? = nil
    
    var dataInfo:Data? = nil
    var ui8BinInfo:[UInt8] = [UInt8]()
    
    var iImgIndex:Int = 0
    var iInfoIndex:Int = 0
    
    //Build [UInt8] as RGBA array from UIImage
    guard uiiImg != nil else {return nil}
    ui8Img = uiiImg!.toRGB()
    
    //Build data from string that will be hided
    dataInfo = strInfo.data(using: .utf8)
    
    //Make Data to Binary(0, 1) array
    guard dataInfo != nil else {return nil}
    for i in dataInfo! {
        ui8BinInfo += dec2bin(data: Int(i), length: 8)
    }
    ui8BinInfo = dec2bin(data: ui8BinInfo.count, length: 64) + ui8BinInfo
    
    //LSB Original Algorithm
    guard ui8Img != nil else {return nil}
    while iInfoIndex < ui8BinInfo.count {
        //Skip Alpha Channel
        guard (iImgIndex + 1) % 4 != 0 else {
            iImgIndex += 1
            continue
        }
        
        if (ui8Img![iImgIndex] & 1) < ui8BinInfo[iInfoIndex] {
            ui8Img![iImgIndex] += 1
        }
        else if (ui8Img![iImgIndex] & 1) > ui8BinInfo[iInfoIndex] {
            ui8Img![iImgIndex] -= 1
        }
        
        if ui8Img![iImgIndex] ~= ui8BinInfo[iInfoIndex] {
            let base = Int.random(in: 0 ... 100), num = Int.random(in: 0 ... 100)
            
            //edge
            if ui8Img![iImgIndex] == 0 {
                ui8Img![iImgIndex] += 1
            }
            else if ui8Img![iImgIndex] == 255 {
                ui8Img![iImgIndex] -= 1
            }
            
            //other
            if num < base {
                ui8Img![iImgIndex] -= 1
            }
            else {
                ui8Img![iImgIndex] += 1
            }
        }
        
        iImgIndex += 1
        iInfoIndex += 1
    }
    
    return ui8Img?.toImage(width: Int(uiiImg!.size.width), height: Int(uiiImg!.size.height), colorSpace: uiiImg!.cgImage!.colorSpace!)
}

func LSB_Match_Take(image uiiImg:UIImage?) -> String? {
    
    var ui8Img:[UInt8]? = nil
    
    var iInfoBinLen:[UInt8] = [UInt8]()
    var iInfoLength:Int = 0
    
    var ui8BinInfo:[UInt8] = [UInt8]()
    var dataInfo:Data = Data()
    
    var iImgIndex:Int = 0
    
    //Build [UInt8] as RGBA array from UIImage
    guard uiiImg != nil else {return nil}
    ui8Img = uiiImg!.toRGB()
    
    //Get Infomation Length
    guard ui8Img != nil else {return nil}
    while iInfoBinLen.count < 64 {
        //Skip Alpha Channel
        guard (iImgIndex + 1) % 4 != 0 else {
            iImgIndex += 1
            continue
        }
        
        iInfoBinLen.append(ui8Img![iImgIndex] & 1)
        iImgIndex += 1
    }
    iInfoLength = bin2dec(binArr: iInfoBinLen)
    
    //Get Binary Infomation
    while ui8BinInfo.count < iInfoLength {
        //Skip Alpha Channel
        guard (iImgIndex + 1) % 4 != 0 else {
            iImgIndex += 1
            continue
        }
        
        ui8BinInfo.append(ui8Img![iImgIndex]&1)
        iImgIndex += 1
    }
    
    //Make infomation from [UInt8] to Data
    for i in stride(from: 0, to: iInfoLength, by: 8) {
        dataInfo.append(UInt8(bin2dec(binArr: [UInt8](ui8BinInfo[i ..< i + 8]))))
    }
    
    return String(data: dataInfo, encoding: .utf8)
}
