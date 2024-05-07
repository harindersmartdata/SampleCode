import Foundation

struct ErrorBase : Codable {
    let message : String?
    let statusCode : Int?
    let data : String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case statusCode = "statusCode"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        data = try values.decodeIfPresent(String.self, forKey: .data)
    }
}

struct messageBase : Codable {
    let status : Int?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}
