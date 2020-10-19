//
//  F5.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/18.
//

import Foundation
import SwiftUI

func F5_Hide(image uiiImg:UIImage?, data strInfo:String) -> UIImage? {
    
    var ui8Img:[UInt8]? = nil
    
    var dataInfo:Data? = nil
    var ui8BinInfo:[UInt8] = [UInt8]()
    
    var iImgIndex:Int = 0
    var iInfoIndex:Int = 0
    var iF5BlockCount:Int = 1
    
    //Hamming Code
    var iH1:UInt8 = 0
    var iH2:UInt8 = 0
    var iH4:UInt8 = 0
    
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
    //長度補成3的倍數
    if ui8BinInfo.count % 3 != 0 {
        ui8BinInfo += [UInt8](repeating: 0, count: 3 - (ui8BinInfo.count % 3))
    }
    
    //F5 Algorithm
    guard ui8Img != nil else {return nil}
    while iInfoIndex < ui8BinInfo.count {
        //Skip Alpha Channel
        guard (iImgIndex + 1) % 4 != 0 else {
            iImgIndex += 1
            continue
        }
        
        switch iF5BlockCount {
        case 1:
            iH1 ^= (ui8Img![iImgIndex] & 1)
        case 2:
            iH2 ^= (ui8Img![iImgIndex] & 1)
        case 3:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH2 ^= (ui8Img![iImgIndex] & 1)
        case 4:
            iH4 ^= (ui8Img![iImgIndex] & 1)
        case 5:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
        case 6:
            iH2 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
        default:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH2 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
            
            let ui8HammingCode:[UInt8] = [iH4, iH2, iH1]
            let ui8InfoL3:[UInt8] = [ui8BinInfo[iInfoIndex + 2], ui8BinInfo[iInfoIndex + 1], ui8BinInfo[iInfoIndex]]
            let iNeedChange:Int = (bin2dec(binArr: ui8HammingCode) ^ bin2dec(binArr: ui8InfoL3)) - 1
            if iNeedChange >= 0 {
                var iCount:Int = 0
                var iChange:Int = iImgIndex
                while iCount < 6 - iNeedChange {
                    guard (iChange + 1) % 4 != 0 else {
                        iChange -= 1
                        continue
                    }
                    iChange -= 1
                    iCount += 1
                }
                if (iChange + 1) % 4 == 0 {
                    iChange -= 1
                }
                ui8Img![iChange] ^= 1
            }
            
            iF5BlockCount = 0
            iH1 = 0
            iH2 = 0
            iH4 = 0
            iInfoIndex += 3
        }
        
        iImgIndex += 1
        iF5BlockCount += 1
    }
    
    return ui8Img?.toImage(width: Int(uiiImg!.size.width), height: Int(uiiImg!.size.height), colorSpace: uiiImg!.cgImage!.colorSpace!)
}

func F5_Take(image uiiImg:UIImage?) -> String? {
    
    var ui8Img:[UInt8]? = nil
    
    var ui8BinInfo:[UInt8] = [UInt8]()
    
    var iInfoLength:Int = 0
    
    var dataInfo:Data = Data()
    
    var iImgIndex:Int = 0
    var iF5BlockCount:Int = 1
    
    //Hamming Code
    var iH1:UInt8 = 0
    var iH2:UInt8 = 0
    var iH4:UInt8 = 0
    
    //Build [UInt8] as RGBA array from UIImage
    guard uiiImg != nil else {return nil}
    ui8Img = uiiImg!.toRGB()
    
    //Get Infomation Length
    guard ui8Img != nil else {return nil}
    while ui8BinInfo.count < 64 {
        //Skip Alpha Channel
        guard (iImgIndex + 1) % 4 != 0 else {
            iImgIndex += 1
            continue
        }
        
        switch iF5BlockCount {
        case 1:
            iH1 ^= (ui8Img![iImgIndex] & 1)
        case 2:
            iH2 ^= (ui8Img![iImgIndex] & 1)
        case 3:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH2 ^= (ui8Img![iImgIndex] & 1)
        case 4:
            iH4 ^= (ui8Img![iImgIndex] & 1)
        case 5:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
        case 6:
            iH2 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
        default:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH2 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
            
            ui8BinInfo += [iH1, iH2, iH4]
            
            iF5BlockCount = 0
            iH1 = 0
            iH2 = 0
            iH4 = 0
        }
        
        iImgIndex += 1
        iF5BlockCount += 1
    }
    iInfoLength = bin2dec(binArr: [UInt8](ui8BinInfo[0 ..< 64]))
    ui8BinInfo = [UInt8](ui8BinInfo[64 ..< ui8BinInfo.count])
    
    //Get Binary Infomation
    while ui8BinInfo.count < iInfoLength {
        //Skip Alpha Channel
        guard (iImgIndex + 1) % 4 != 0 else {
            iImgIndex += 1
            continue
        }
        
        switch iF5BlockCount {
        case 1:
            iH1 ^= (ui8Img![iImgIndex] & 1)
        case 2:
            iH2 ^= (ui8Img![iImgIndex] & 1)
        case 3:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH2 ^= (ui8Img![iImgIndex] & 1)
        case 4:
            iH4 ^= (ui8Img![iImgIndex] & 1)
        case 5:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
        case 6:
            iH2 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
        default:
            iH1 ^= (ui8Img![iImgIndex] & 1)
            iH2 ^= (ui8Img![iImgIndex] & 1)
            iH4 ^= (ui8Img![iImgIndex] & 1)
            
            ui8BinInfo += [iH1, iH2, iH4]
            
            iF5BlockCount = 0
            iH1 = 0
            iH2 = 0
            iH4 = 0
        }
        
        iImgIndex += 1
        iF5BlockCount += 1
    }
    
    //Make infomation from [UInt8] to Data
    for i in stride(from: 0, to: iInfoLength, by: 8) {
        dataInfo.append(UInt8(bin2dec(binArr: [UInt8](ui8BinInfo[i ..< i + 8]))))
    }
    
    return String(data: dataInfo, encoding: .utf8)
}
