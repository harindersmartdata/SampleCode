/*
 Copyright (c) 2018 smartData
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import UIKit

let kAppVersionWithoutProp = false

enum AppStoryboard : String {
    case Main
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

struct Identifiers {
    static let navigation = "mainNav"
}

unowned(unsafe) var delegate: UIApplicationDelegate?
let AppDelegateInstance = UIApplication.shared.delegate as! AppDelegate

public func printLogs(_ string: String?){
#if DEBUG
    print("\n Logs: \(string ?? "")")
#else
#endif
}


class AppInstance: NSObject {
    
    static let appDelegateInstance = UIApplication.shared.delegate as! AppDelegate
    static let shared = AppInstance()
    var authToken:String?
    var userId : String?
    var userData: UserData?
    
    override init() {
        super.init()
    }
    
    public func getKeyWindow() -> UIWindow?{
        guard let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first else{
                    return nil
                }
        return keyWindow
    }
    public func userLoggedOut(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userEmail)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.token)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.onCallNumber)
        UserDefaults.standard.synchronize()
    }
    public func setLogin() {
        self.userLoggedOut()
    }
    func setHomeToRootVC(){
        let storyboard = AppStoryboard.Main.instance
        let initialViewController = storyboard.instantiateViewController(withIdentifier: Controller.MainTab)
        UIApplication.shared.windows.first?.rootViewController = initialViewController
    }
}


