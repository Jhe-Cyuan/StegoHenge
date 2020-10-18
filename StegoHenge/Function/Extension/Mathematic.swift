//
//  Mathematic.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/17.
//

import Foundation
import SwiftUI

func dec2bin(data number:Int, length size:Int) -> [UInt8] {
    var number:Int = number
    var bin:[UInt8] = [UInt8]()
    while number != 0 || bin.count % size != 0 || bin.count == 0 {//F || (T && F)
        bin.append(UInt8(number % 2))
        number /= 2
    }
    return bin.reversed()
}

func bin2dec(binArr arr:[UInt8]) -> Int {
    var number:Int = 0;
    for i in arr {
        number = (number*2)+Int(i)
    }
    return number
}
