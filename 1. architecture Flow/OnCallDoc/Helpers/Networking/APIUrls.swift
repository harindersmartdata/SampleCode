
import Foundation

let BaseUrl : String = "example.com"

enum Path {
    static let  user = "user/"
    static let controller = "/api/"
}

enum APIName {
    static let Signup = "user/register"
    static let login = "user/login"
    static let changePassword = "user/change-password"
    static let logOut = "user/logout"
    static let userInfo =  "user/profile-info"
    static let updateUserProfile = "user/update-profile"
    static let updateUserProfilePic = "user/upload-image"
    static let twilioToken = "twilio"
    static let forgotPassword = "user/forgot-password"
    static let startCallRecording = "twilio/recording"
    static let stopCallRecording = "twilio/recording_stop"
    static let callLogs = "twilio/call_logs"
    static let deleteCallLogs = "twilio/delete_call_logs"
    static let getNotificationsList = "notification/get"
    static let clearAllNotification = "notification/delete-all"
    static let readAllNotification = "notification/update-status"
    static let getNotificationCount = "notification/get-notfy-count"
    static let sendMessage = "twilio/send-sms"
    static let getUserListForSMS = "twilio/get-sms-log"
    static let getSMS = "twilio/get-user-conversation"
    static let toggleNotification = "user/toggle-notification-status"
    static let getTranscription = "twilio/get-transcription"
}

enum Keys {
    static let encryptedData = "data"
    static let firstName    = "firstName"
    static let lastName    = "lastName"
    static let dob = "dob"
    static let gender = "gender"
    static let ethnicity = "ethnicity"
    static let npi = "npi"
    static let practiceAddress = "practiceAddress"
    static let credentail = "credentail"
    static let phone = "phone"
    static let email    = "email"
    static let password    = "password"
    static let newPassword = "newPassword"
    static let transcribeEmail = "transcribeEmail"
    static let suiteAddress = "suiteAddress"
    static let state = "state"
    static let zip = "zip"
    static let deviceToken = "deviceToken"
    static let userId  = "userId"
    static let identity = "identity"
    static let callSID = "callSid"
    static let callSids = "callSids"
    static let token = "token"
    static let notification = "notificationStatus"
    static let number = "number"
    static let to = "to"
    static let from = "from"
    static let body = "body"
    static let profilePic = "profilePic"
    static let twilioNumber = "twilioNumber"
}