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
            debugPrint("init aes instance error,err:\(error)")
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
            debugPrint("encrypted message error ,err:\(error)")
        }
        // 转base64
        return encrypted.toBase64()
    }
    
//    static func decrypt(source : String) -> String{
//        if source.isBlank { return ""}
//        if aes == nil{
//            let _ = initAES()
//        }
//                
//        guard let aes = aes else{
//            return source
//        }
//        // 解密
//        let needDecrypto = [UInt8](base64: source)
//        var str = "decrypto error"
//        do {
//            let decode = try aes.decrypt(needDecrypto)
//            let decodeData = Data(decode)
//            str = String(data: decodeData, encoding: .utf8) ?? ""
//        } catch let error {
//            debugPrint("decode log message error,err:\(error)")
//        }
//        return str
//    }
    
    static func decrypt(source : String) -> String{
        if source.isBlank { return ""}
        
        let ivBytes = source.bytes.prefix(16)
        let needDecrypto = source.bytes.dropFirst(16)
        
        let ivStr = String(bytes: ivBytes, encoding: .utf8) ?? ""

        // 解密
        var str = "decrypto error"
        do {
            aes = try AES(key: key, iv: ivStr, padding: .pkcs7)
            if let decode = try aes?.decrypt(needDecrypto){
                let decodeData = Data(decode)
                str = String(data: decodeData, encoding: .utf8) ?? ""
            }
        } catch let error {
            debugPrint("decode log message error,err:\(error)")
        }
        return str
    }

    
//    func decrypt(psw: String, base64Ciphertext: String) -> String? {
//        guard let keyData = psw.data(using: .utf8),
//              let encryptedData = Data(base64Encoded: base64Ciphertext) else { return nil }
//
//        // 截取前16字节作为IV
//        let iv = encryptedData.prefix(16)
//        let ciphertext = encryptedData.dropFirst(16)
//        
//        let aes = try? AES(key: psw, iv: String(data: encryptedData, encoding: .utf8) ?? "", padding: .pkcs7)
//        aes?.decrypt(ciphertext)
//        
//        return nil
//    }
//
//    // 使用PKCS#7解除填充
//    func unpad(_ data: Data) -> Data {
//        let padding = data.last!
//        return data.dropLast(Int(padding))
//    }
    
    
}

