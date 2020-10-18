//
//  RSAKey.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/17.
//

import Foundation
import SwiftUI

func buildRSAKey() -> (privateKey:SecKey?, publicKey:SecKey?) {
    //建立私密金鑰的屬性，使用ＲＳＡ演算法，長度為2048位元
    //不存放於鑰匙圈，標籤為RSA privatekey
    let attributes:[String:Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrKeySizeInBits as String: 2048,//金鑰長度＝密文長度
        kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: false,
            kSecAttrLabel as String: "RSA privatekey"
        ]
    ]
    var error:Unmanaged<CFError>?
    
    //建立私密金鑰
    let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error)

    //使用私密金鑰產生公開金鑰
    let publicKey = SecKeyCopyPublicKey(privateKey!)
    
    return (privateKey, publicKey)
}
/*
//建立私密金鑰的屬性，使用ＲＳＡ演算法，長度為2048位元
//不存放於鑰匙圈，標籤為RSA privatekey
let attributes:[String:Any] = [
    kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
    kSecAttrKeySizeInBits as String: 2048,
    kSecPrivateKeyAttrs as String: [
        kSecAttrIsPermanent as String: false,
        kSecAttrLabel as String: "RSA privatekey"
    ]
]
var error: Unmanaged<CFError>?

//建立私密金鑰
let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error)

//使用私密金鑰產生公開金鑰
let publicKey = SecKeyCopyPublicKey(privateKey!)

//宣告加解密演算法
let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512

//需要加密之訊息
let StringPlainText = "測試"

//將訊息轉為Data型態用來加密
let plainText = StringPlainText.data(using: .utf8)!

//將訊息從Data轉為CFData並加密為密文
let cipherText = SecKeyCreateEncryptedData(publicKey!, algorithm, plainText as CFData, &error)

//CFData密文解密，並回傳Data之訊息
let DecryptedPlainText = SecKeyCreateDecryptedData(privateKey!, algorithm, cipherText!, &error) as Data?

//將解密之訊息轉為字串
let DecryptedStringPlainText = String(data: DecryptedPlainText!, encoding: .utf8)
*/
