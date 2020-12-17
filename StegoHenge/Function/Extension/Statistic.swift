//
//  Statistic.swift
//  StegoHenge
//
//  Created by 許騰尹 on 2020/12/6.
//

import Foundation
import SwiftUI

func psnrCounter(height m:Int, width n:Int, original ui8CarrierImg:[UInt8], hided ui8HidedImg:[UInt8]) -> (Double, Double) {
    var psnr:Double = 0;
    var mse:Double = 0;
    
    for i in 0 ..< m * n * 4 {
        if (i+1) % 4 != 0 {
            mse += pow(Double(ui8CarrierImg[i]) - Double(ui8HidedImg[i]), 2)
        }
    }
    
    mse /= Double(3 * m * n)
    
    psnr = 10 * log10(pow(255, 2) / mse)
    
    return (mse, psnr);
}
