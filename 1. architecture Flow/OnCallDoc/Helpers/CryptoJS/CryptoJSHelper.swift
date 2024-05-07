import Foundation

class CryptoJSHelper{
    
    static let shared = CryptoJSHelper()
    private let AES = CryptoJS.AES()
    
    private init(){}
    
    func encryptedStringToDic(encryptedData: String) -> [String: Any]?{
        let decryptedString = AES.decrypt(encryptedData, password: ClientID.encryptionKey)
        let dataDict = decryptedString.convertToDictionary()
        
        return dataDict
    }
    func dictionaryToEncryptedString(params: [String: String]) -> String{
        let jsonString = convertToJsonString(dict: params)
        let encryptedData = AES.encrypt(jsonString, password: ClientID.encryptionKey)
        
        return encryptedData
    }
    
    private func convertToJsonString(dict: [String : String]) -> String{
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dict) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
    
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
}
