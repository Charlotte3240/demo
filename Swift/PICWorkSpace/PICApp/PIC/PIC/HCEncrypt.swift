//
//  Ex.swift
//  PIC
//
//  Created by m1 on 2024/3/28.
//


import Foundation


class HCEncrypt{
    static var aes : AES?
    
    fileprivate static let key = "1234567890123456"
    fileprivate static let iv = "1234567890123456"

    static func initAES() -> AES?{
        do {
            aes = try AES(key: key, iv: iv, padding: .pkcs7)
            return aes
        } catch let error {
            HClog.log("init aes instance error,err:\(error)")
        }
        return nil
    }
    
    static func encrypt(source : String) -> String{
        if source.isBlank { return ""}
        if aes == nil{
            let _ = initAES()
        }
        guard let aes = aes else{
            return source
        }
        // byte 数组
        var encrypted: [UInt8] = []
        do {
            encrypted = try aes.encrypt(source.bytes)
        } catch let error{
            HClog.log("encrypted message error ,err:\(error)")
        }
        // 转base64
        return encrypted.toBase64()
    }
    
    static func decrypt(psw: String, encryptedText: String) -> String? {
        guard let keyData = psw.data(using: .utf8),
              let encryptedData = Data(base64Encoded: encryptedText) else { return nil }
        do {

            let iv = encryptedData.prefix(16)
            let ciphertext = encryptedData.dropFirst(16)

            let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: Data(iv).bytes),padding: .pkcs7)
                                    
            let decryptedBytes = try aes.decrypt(Data(ciphertext).bytes)
            let decodeData = Data(decryptedBytes)
            
            if let decryptedText = String(data: decodeData, encoding: .utf8) {
                return decryptedText
            } else {
                return nil
            }
        } catch let error {
            print("Decryption error:", error)
            return nil
        }

    }
    
}

