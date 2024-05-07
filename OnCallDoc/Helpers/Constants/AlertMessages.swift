import Foundation

// Constants
let OK                  = "OK"
let AppSettings         = "Settings"
let Error               = "Error"
let Cancel              = "Cancel"
let Done                = "Done"
let camera              = "Camera"
let photoLib            = "Photos Library"


public struct AlertMessage {
    static let AppName                  = "OnCallDoc"
    static let invalidURL               = "Invalid server URL."
    static let lostInternet             = "It seems you are offline. Please check your Internet connection."
    static let sessionExpire            = "Your session has expired. Please try to log in again!"
    static var noDataFound              = "No data found."
    static let somethingWentWrong       = "Something went wrong. Please try again."
    static let logoutConfirmation       = "Are you sure you want to logout?"
    static let openSettings             = "Open Settings"
    static let chooseOption             = "Choose Option"
    static let noOncallDocNumber        = "You don't have any OnCallDoc number assigned. Please contact support!"
    
    // Validations Struct
    struct Validations {
        static let firstNameEmpty        = "Please enter first name."
        static let lastNameEmpty         = "Please enter last name."
        static let dobEmpty              = "Please enter date of birth."
        static let genderEmpty           = "Please select gender."
        static let ethinicityEmpty       = "Please enter race/ethnicity."
        static let npiEmpty              = "Please enter NPI."
        static let practiceAddressEmpty  = "Please enter practice address."
        static let credentialEmpty       = "Please select credential."
        static let phoneNumberEmpty      = "Please enter phone number."
        static let invalidPhoneNumber    = "Please enter a valid phone number."
        static let invalidEmail          = "Please enter a valid email address."
        static let invalidEmailTrans     = "Please enter a valid transcriptions email address."
        static let emailEmpty            = "Please enter email address."
        static let passwordEmpty         = "Please enter password."
        static let passwordWeak          = "Please enter minimum 6 characters for Password."
        static let newPasswordEmpty      = "Please enter new password."
        static let confirmPasswordEmpty  = "Please enter confirm password."
        static let oldPasswordEmpty      = "Please enter your current password."
        static let passwordNotMatch      = "New password & confirm password do not match."
        static let stateEmpty            = "Please select state."
        static let zipEmpty              = "Please enter zip code."
    }
    
    // JSON Struct
    struct Json {
        static let decodingError          = "Could not decode data."
    }
    
    // Permissions
    static let cameraPermission          = "Please allow camera permission to capture image in settings."
    static let photosPermission          = "Please allow access photos to save image in settings."
}

