/*
 Copyright (c) 2018 smartData
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import UIKit
//import OAuthSwift
import CommonCrypto

extension String {
    
    func parse<D>(to type: D.Type) -> D? where D: Decodable {

          let data: Data = self.data(using: .utf8)!

          let decoder = JSONDecoder()

          do {
              let _object = try decoder.decode(type, from: data)
              return _object

          } catch {
              return nil
          }
      }
    /*
     Method: isInputValidForEmail
     Functionality: Validates input with allowed characters, Checks the max limit for input value
     Return: true if input value is allowed to be entred otherwise false
     */
    public func isInputValidForEmail(_ string: String) -> Bool{
        if  string == " "
        {
            return false
        }
        // Email cannot have more than one @
        if  (string == "@") {
            do {
                let regex = try NSRegularExpression(pattern: "@", options: .caseInsensitive)
                let matches = regex.numberOfMatches(in: self , options: [], range: NSMakeRange(0, self.count))
                if matches >= 1
                {
                    return false
                }
            }
            catch
            {
            }
        }
        
        if self.count > MaxLimit.email
        {
            return false
        }
        return true
    }
    /*
     Method: isValidEmail
     Functionality: Validates input with format of email
     Return: true if input value is valid format of email.
     */
    func isValidEmail() -> Bool {
        let stricterFilterString : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailId : NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return emailId.evaluate(with: self)
    }
    
    /*
     Method: isValidphoneNumber
     Functionality: Validates input with format of email
     Return: true if input value is valid format of email.
     */
    func isValidPhoneNumber() -> Bool {
        if self.count < 10
        {
            return false
        }
        return true
    }
    /*
     applyPatternOnNumbers:
     Set phone number as USA phone number format
     */
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    /*
     Method: isInputValidForPassword
     Functionality: Validates input with allowed characters, Checks the max limit for input value
     Return: true if input value is allowed to be entred otherwise false
     */
    func isInputValidForPassword(_ string: String) -> Bool {
        if  string == " "
        {
            return false
        }
        if self.count > MaxLimit.password
        {
            return false
        }
        return true
    }
    
    /*
     Method: isInputValidForBussinessName
     Functionality: Validates input with allowed characters, Checks the max limit for input value
     Return: true if input value is allowed to be entred otherwise false
     */
    func isInputValidForName(_ string: String) -> Bool {
        if self.count > MaxLimit.fullName
        {
            return false
        }
        return true
    }
    
    /*
     downloadFilefromURL:
     It downloads the image from the given URL and returns the uiimage
     */
    func downloadFilefromURL(_ completion:@escaping((_ image: UIImage?)->Void))  {
        guard URL(string: self) != nil else {
            return completion(nil)
        }
        do {
            let imageData = try Data.init(contentsOf: URL.init(string: self) ?? URL.init(string: "")!)
            let image = UIImage(data: imageData)
            completion(image)
        }
        catch _ {
            // Error handling
        }
    }
    
    func convertISODate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let date =  dateFormatter.date(from: self)
        let formatter = ISO8601DateFormatter()
        let string = formatter.string(from: date!)
        if  let date = formatter.date(from: string)
        {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM dd, yyyy, h:mm a"
            let currentTime = dateFormat.string(from: date)
            return currentTime
        }
        return "NA"
    }
    
    func toUInt() -> UInt16? {
        let scanner = Scanner(string: self)
        var u: UInt64 = 0
        if scanner.scanUnsignedLongLong(&u)  && scanner.isAtEnd {
            return UInt16(u)
        }
        return nil
    }
    
    func length() -> Int {
        return self.count
    }
    
    var nsdata: Data {
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    func setAsSuperscript(_ textToSuperscript: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let foundRange = attributedString.mutableString.range(of: textToSuperscript)
        
        let font = UIFont.systemFont(ofSize: 12)
        if foundRange.location != NSNotFound {
            attributedString.addAttribute(.font, value: font, range: foundRange)
            attributedString.addAttribute(.baselineOffset, value: 3, range: foundRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: foundRange)
        }
        return attributedString
    }
    
    var extractInteger: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
                        .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    
    func secondsFromString(_ hoursSec: String?, minSeconds: String?) -> String?
    {
        if let timeEst = hoursSec, timeEst.count > 0
        {
            //    guard let timeEst = strTime else
            //    {
            //      return nil
            //    }
            var hr = 0
            var min = 0
            var sec = 0
            let stringArray = timeEst.components(separatedBy: " ")
            var indexCheck = 0
            for item in stringArray {
                if let number = Int(item.extractInteger) {
                    if indexCheck == 0
                    {
                        hr = number
                        indexCheck = indexCheck+1
                    }
                    else if indexCheck == 1
                    {
                        min = number
                        indexCheck = indexCheck+1
                    }
                    else if indexCheck == 2
                    {
                        sec = number
                        indexCheck = indexCheck+1
                    }
                }
            }
            let totalTime = (hr*60)*60+min*60+sec
            return "\(totalTime)"
        }
        else if let timeEst = minSeconds, timeEst.count > 0
        {
            //    guard let timeEst = strTime else
            //    {
            //      return nil
            //    }
            var min = 0
            var sec = 0
            let stringArray = timeEst.components(separatedBy: " ")
            var indexCheck = 0
            for item in stringArray {
                if let number = Int(item.extractInteger) {
                    if indexCheck == 0
                    {
                        min = number
                        indexCheck = indexCheck+1
                    }
                    else if indexCheck == 1
                    {
                        sec = number
                        indexCheck = indexCheck+1
                    }
                }
            }
            let totalTime = min*60+sec
            return "\(totalTime)"
        }
        return nil
    }
    
    /* func hourFortmattedTime() -> String? {
     let totalSeconds = Double(self)
     if totalSeconds ?? 0 > 0
     {
     let hours : Double = (totalSeconds ?? 0.0) / 3600.0
     let seconds: Double = (totalSeconds ?? 0.0).truncatingRemainder(dividingBy: 60.0)
     let minutes: Double = ((totalSeconds ?? 0.0) / 60.0).truncatingRemainder(dividingBy: 60.0)
     if Int(hours) <= 0 && Int(minutes) <= 0
     {
     return String(format: "%02iSec", Int(seconds))
     }
     if Int(hours) <= 0 && Int(seconds) <= 0
     {
     return String(format: "%02iMin", Int(minutes))
     }
     if Int(hours) <= 0
     {
     return String(format: "%02iMin %02iSec", Int(minutes), Int(seconds))
     }
     else {
     return String(format:"%2iHr %02iMin %02iSec", Int(hours), Int(minutes), Int(seconds))
     }
     }
     return nil
     }*/
    func hourFortmattedTime() -> String? {
        let totalSeconds = Double(self)
        if totalSeconds ?? 0 > 0
        {
            let hours : Double = (totalSeconds ?? 0.0) / 3600.0
            let seconds: Double = (totalSeconds ?? 0.0).truncatingRemainder(dividingBy: 60.0)
            let minutes: Double = ((totalSeconds ?? 0.0) / 60.0).truncatingRemainder(dividingBy: 60.0)
            if Int(hours) <= 0 && Int(minutes) <= 0
            {
                return String(format: "00:00:%02i", Int(seconds))
            }
            if Int(hours) <= 0 && Int(seconds) <= 0
            {
                return String(format: "00:%02i:00", Int(minutes))
            }
            if Int(hours) <= 0
            {
                return String(format: "00:%02i:%02i", Int(minutes), Int(seconds))
            }
            else {
                return String(format:"%2i:%02i:%02i", Int(hours), Int(minutes), Int(seconds))
            }
        }
        return nil
    }
    func hourFortmattedTimeIfOnlySec() -> String? {
        let totalSeconds = Double(self)
        if totalSeconds ?? 0 > 0
        {
            let hours : Double = (totalSeconds ?? 0.0) / 3600.0
            let seconds: Double = (totalSeconds ?? 0.0).truncatingRemainder(dividingBy: 60.0)
            let minutes: Double = ((totalSeconds ?? 0.0) / 60.0).truncatingRemainder(dividingBy: 60.0)
            if Int(hours) <= 0 && Int(minutes) <= 0
            {
                return String(format: "00:%02i", Int(seconds))
            }
            if Int(hours) <= 0 && Int(seconds) <= 0
            {
                return String(format: "%02i:00", Int(minutes))
            }
            if Int(hours) <= 0
            {
                return String(format: "%02i:%02i", Int(minutes), Int(seconds))
            }
            else {
                return String(format:"%2i:%02i:%02i", Int(hours), Int(minutes), Int(seconds))
            }
        }
        return nil
    }
    var queryDictionary: [String: String]? {
        
        var queryStrings = [String: String]()
        for pair in self.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
    
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else {
            return 0
        }
        
        var interval:Double = 0
        
        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate()
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
    func sessionTime() -> String? {
        let seconds = Int(self.extractInteger) ?? 0
        if seconds > 0
        {
            return "\(seconds/60)"+"min"
        }
        return "0min"
        
    }
    func avgTimeInHour() -> String? {
        let seconds = Int(self.extractInteger) ?? 0
        if seconds > 0
        {
            return "\(seconds/3600)"+"h"
        }
        return "0h"
        
    }
    
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.doubleValue
    }
    
}

extension NSMutableAttributedString {
    func appendAttributedText(text2: NSMutableAttributedString)->NSMutableAttributedString {
        self.append(text2)
        return self
    }
}

struct DictionaryEncoder {
    static func encode<T>(_ value: T) throws -> [String: Any] where T: Encodable {
        let jsonData = try JSONEncoder().encode(value)
        return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
    }
}


extension Int {
    func hourFortmattedTime() -> String? {
        let totalSeconds = Double(self)
        if totalSeconds > 0
        {
            let hours : Double = (totalSeconds) / 3600.0
            let seconds: Double = (totalSeconds).truncatingRemainder(dividingBy: 60.0)
            let minutes: Double = ((totalSeconds) / 60.0).truncatingRemainder(dividingBy: 60.0)
            if Int(hours) <= 0 && Int(minutes) <= 0
            {
                return String(format: "00:00:%02i", Int(seconds))
            }
            if Int(hours) <= 0 && Int(seconds) <= 0
            {
                return String(format: "00:%02i:00", Int(minutes))
            }
            if Int(hours) <= 0
            {
                return String(format: "00:%02i:%02i", Int(minutes), Int(seconds))
            }
            else {
                return String(format:"%2i:%02i:%02i", Int(hours), Int(minutes), Int(seconds))
            }
        }
        return nil
    }
    
    
}

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

