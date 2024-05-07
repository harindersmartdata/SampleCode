import Foundation

enum UserDefaultsKeys {
    static let token = "token"
    static let userID = "UserID"
    static let deviceToken = "DeviceToken"
    static let userEmail = "userEmail"
    static let twilioToken = "twilioToken"
    static let onCallNumber = "onCallNumber"
    static let boolForIncomingCall = "boolForIncomingCall"
    static let activeCallID = "activeCallID"
}

public func isIncomingCall() -> Bool?{
    if let bool: Bool = UserDefaults.standard.value(forKey: UserDefaultsKeys.boolForIncomingCall) as? Bool{
        return bool
    }
    return false
}


public func activeCallID() -> String?{
    if let id: String = UserDefaults.standard.value(forKey: UserDefaultsKeys.activeCallID) as? String{
        return id
    }
    return ""
}

public func onCallNumber() -> String?{
    if let onCallNumber: String = UserDefaults.standard.value(forKey: UserDefaultsKeys.onCallNumber) as? String{
        return onCallNumber
    }
    return ""
}

public func twilioToken() -> String?{
    if let twilioToken: String = UserDefaults.standard.value(forKey: UserDefaultsKeys.twilioToken) as? String{
        return twilioToken
    }
    return ""
}

public func userID() -> String?{
    if let id: String = UserDefaults.standard.value(forKey: UserDefaultsKeys.userID) as? String{
        return id
    }
    return ""
}


public func deviceToken() -> String{
    if let token: String = UserDefaults.standard.value(forKey: UserDefaultsKeys.deviceToken) as? String{
        return token
    }
    return ""
}

public func userToken() -> String?{
    if let token: String = UserDefaults.standard.value(forKey: UserDefaultsKeys.token) as? String{
        return token
    }
    return ""
}

public func userEmail() -> String?{
    if let token: String = UserDefaults.standard.value(forKey: UserDefaultsKeys.userEmail) as? String{
        return token
    }
    return ""
}
