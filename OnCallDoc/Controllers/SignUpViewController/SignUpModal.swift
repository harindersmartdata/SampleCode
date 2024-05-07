import Foundation

struct SignUp : Codable {
    let statusCode : Int?
    let data : String?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "code"
        case data = "data"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}
struct SignUpData : Codable {
    let token : String?
    let userdata : userDataSignup?
    
    enum CodingKeys: String, CodingKey {
        case  token = "token"
        case  userdata = "userdata"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        userdata = try values.decodeIfPresent(userDataSignup.self, forKey: .userdata)
    }
    
}

struct userDataSignup : Codable {
    let id : String?
    let firstName: String?
    let lastName : String?
    let dob : String?
    let gender : String?
    let ethnicity : String?
    let npi : String?
    let practiceAddress : String?
    let credentail : String?
    let profilePic : String?
    let phone : String?
    let email : String?
    let transcribeEmail : String?
    
    
    enum CodingKeys: String, CodingKey {
        case  id = "id"
        case  firstName = "firstName"
        case  lastName = "lastName"
        case  dob = "dob"
        case  gender = "gender"
        case  ethnicity = "ethnicity"
        case  npi = "npi"
        case  practiceAddress = "practiceAddress"
        case  credentail = "credentail"
        case  profilePic = "profilePic"
        case  phone = "phone"
        case  email = "email"
        case transcribeEmail = "transcribeEmail"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        ethnicity = try values.decodeIfPresent(String.self, forKey: .ethnicity)
        npi = try values.decodeIfPresent(String.self, forKey: .npi)
        practiceAddress = try values.decodeIfPresent(String.self, forKey: .practiceAddress)
        credentail = try values.decodeIfPresent(String.self, forKey: .credentail)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        transcribeEmail = try values.decodeIfPresent(String.self, forKey: .transcribeEmail)
    }
    
}

