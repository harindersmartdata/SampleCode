/*
Copyright (c) 2018 smartData

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import UIKit

extension UIApplication {
    
  public var languageCode: String {
       let appLang = UserDefaults.standard.string(forKey: "app_lang") ?? "en"
      return appLang
//        let supportedLanguageCodes = ["en", "ar"]
//        let languageCode = Locale.current.languageCode ?? "en"
//
//        return supportedLanguageCodes.contains(languageCode) ? languageCode : "en"
  }
  
    internal class func topViewController() -> UIViewController? {
//      let keyWindow = UIApplication.shared.windows.first
//      return keyWindow?.rootViewController
      var topController: UIViewController? = UIApplication.shared.windows.first?.rootViewController
              while ((topController?.presentedViewController) != nil) {
                  topController = topController?.presentedViewController
              }
              return topController!
    }
  
 internal class func goToSettings()
  {
    if let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
      if UIApplication.shared.canOpenURL(appSettings) {
        UIApplication.shared.open(appSettings)
      }
    }
  }
  
  internal class func showPermissionErrorMessage(_ message: String) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
    alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { _ in
      alertWindow.isHidden = true
    }))
    alertController.addAction(UIAlertAction(title: AppSettings, style: UIAlertAction.Style.default, handler: { _ in
      alertWindow.isHidden = true
      UIApplication.goToSettings()
    }))
    alertWindow.windowLevel = UIWindow.Level.alert + 1;
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
  }
  
  internal class func showErrorMessage(_ message: String) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
    alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { _ in
      alertWindow.isHidden = true
    }))
    alertController.addAction(UIAlertAction(title: kAppName, style: UIAlertAction.Style.default, handler: { _ in
      alertWindow.isHidden = true
    }))
    alertWindow.windowLevel = UIWindow.Level.alert + 1;
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
  }
  
}

extension Encodable {

    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
