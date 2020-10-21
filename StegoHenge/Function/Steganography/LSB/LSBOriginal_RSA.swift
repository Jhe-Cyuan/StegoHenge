//
//  LSBOriginal_RSA.swift
//  StegoHenge
//
//  Created by 許騰尹 on 2020/10/22.
//

import Foundation
import SwiftUI

func LSB_RSA_Hide(image uiiImg:UIImage?, data strInfo:String, key rsaKey:String?) ->UIImage? {
    
    var ui8Img:[UInt8]? = nil
    
    var dataInfo:Data? = nil
    var ui8BinInfo:[UInt8] = [UInt8]()
    
    var iImgIndex:Int = 0
    var iInfoIndex:Int = 0
    
    var publicKey:SecKey?
    
    //Get RSA public key from string
    guard rsaKey != nil else {return nil}
    publicKey = buildKeyFromString_Public(string: rsaKey!)
    
    //Build [UInt8] as RGBA array from UIImage
    guard uiiImg != nil else {return nil}
    ui8Img = uiiImg!.toRGB()
    
    //Build data from string that will be hided
    dataInfo = strInfo.data(using: .utf8)
    
    //Make Data encode by RSA key and to binary array
    guard dataInfo != nil else {return nil}
    dataInfo = SecKeyCreateEncryptedData(publicKey!, .rsaEncryptionOAEPSHA512, dataInfo! as CFData, nil) as Data?
    for i in dataInfo! {
        ui8BinInfo += dec2bin(data: Int(i), length: 8)
    }
    
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
        iImgIndex += 1
        iInfoIndex += 1
    }
    
    return ui8Img?.toImage(width: Int(uiiImg!.size.width), height: Int(uiiImg!.size.height), colorSpace: uiiImg!.cgImage!.colorSpace!)
}

func LSB_RSA_Take(image uiiImg:UIImage?, key rsaKey:String?) -> String? {
    
    var ui8Img:[UInt8]? = nil
    
    var ui8BinInfo:[UInt8] = [UInt8]()
    var dataInfo:Data = Data()
    
    var iImgIndex:Int = 0
    
    var privateKey:SecKey?
    
    var strDecodeInfo:String?
    
    //Get RSA public key from string
    guard rsaKey != nil else {return nil}
    privateKey = buildKeyFromString_Private(string: rsaKey!)
    
    //Build [UInt8] as RGBA array from UIImage
    guard uiiImg != nil else {return nil}
    ui8Img = uiiImg!.toRGB()
    
    //Get Binary Infomation
    while ui8BinInfo.count < 2048 {
        //Skip Alpha Channel
        guard (iImgIndex + 1) % 4 != 0 else {
            iImgIndex += 1
            continue
        }
        
        ui8BinInfo.append(ui8Img![iImgIndex]&1)
        iImgIndex += 1
    }
    
    //Make infomation from [UInt8] to Data
    for i in stride(from: 0, to: 2048, by: 8) {
        dataInfo.append(UInt8(bin2dec(binArr: [UInt8](ui8BinInfo[i ..< i + 8]))))
    }
    
    guard privateKey != nil else {return nil}
    dataInfo = SecKeyCreateDecryptedData(privateKey!, .rsaEncryptionOAEPSHA512, dataInfo as CFData, nil)! as Data
    
    strDecodeInfo = String(data: dataInfo, encoding: .utf8)
    
    return strDecodeInfo ?? nil
}
