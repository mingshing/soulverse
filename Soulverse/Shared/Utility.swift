//
//  Utility.swift
//

import Foundation
import SwiftyBase64

class Utility {
    
    static func getAppVersion() -> String {
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return versionNumber + "." + buildNumber
    }
    
    static func base64Encode(_ data: Data) -> String {
        let bytes = [UInt8](data)
        let result = SwiftyBase64.EncodeString(bytes, alphabet: .URLAndFilenameSafe)
        
        //print(result)
        return result
    }
    
    static func getDoubleValue(_ value: Any?) -> Double? {
        guard value != nil else { return nil }
        
        if let doubleType = value as? Double {
            return doubleType
        }
        if let intType = value as? Int {
            return Double(intType)
        }
        
        if let stringType = value as? String {
            return Double(stringType)
        }
        return nil
    }
}
