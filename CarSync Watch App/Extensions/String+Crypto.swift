//
//  String+Extension.swift
//  LLBWidgetExtension
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif
import CommonCrypto

extension JanlorLeeWrapper where Base == String {
    var md5: String {
        if #available(iOS 13.0, watchOS 6.0, *) {
            let digest = Insecure.MD5.hash(data: base.data(using: .utf8) ?? Data())
            return digest.map { String(format: "%02hhx", $0) }.joined()
        } else {
            guard let data = base.data(using: .utf8) else {
                return base
            }
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
#if swift(>=5.0)
            _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }
#else
            _ = data.withUnsafeBytes { bytes in
                return CC_MD5(bytes, CC_LONG(data.count), &digest)
            }
#endif
            return digest.map { String(format: "%02x", $0) }.joined()
        }
    }
    
//    var md5 :String {
//        let str = cString(using: String.Encoding.utf8)
//        let strLen = CUnsignedInt(base.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_MD5(str!, strLen, result)
//
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deallocate()
//        return String(format: hash as String)
//    }
}
