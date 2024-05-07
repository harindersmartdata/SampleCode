import UIKit
import IQKeyboardManagerSwift // Import IQKeyboardManagerSwift for managing keyboard
import DropDown // Import DropDown for dropdown functionality
import Firebase // Import Firebase for Firebase services
import FirebaseMessaging // Import FirebaseMessaging for handling Firebase Cloud Messaging
import PushKit // Import PushKit for VoIP push notifications

// Protocol to handle PushKit events
protocol PushKitEventDelegate: AnyObject {
    func credentialsUpdated(credentials: PKPushCredentials) -> Void // Method to handle updated push credentials
    func credentialsInvalidated() -> Void // Method to handle invalidated push credentials
    func incomingPushReceived(payload: PKPushPayload) -> Void // Method to handle incoming push notifications
    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) -> Void // Method to handle incoming push notifications with completion
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {
    
    var win = UIWindow() // Window instance
    let gcmMessageIDKey = "gcm.message_id" // Key for GCM message ID
    var pushKitEventDelegate: PushKitEventDelegate? // PushKit event delegate
    var voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main) // VoIP Push registry

    // Method called when the application finishes launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let id = userID(), id != "" { // Check if user ID exists
            AppInstance.shared.setHomeToRootVC() // Set home view controller as root view controller
        }
        // Enable IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard() // Start listening to keyboard for DropDown
        FirebaseApp.configure() // Configure Firebase
        registerForPushNotification(application) // Register for push notifications
        
        return true
    }
    
    // Method to register for push notifications
    func registerForPushNotification(_ application: UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 and above, request user authorization for notifications
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _,_ in }
        } else {
            // For iOS 9 and below, register user notification settings
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // Register for remote notifications
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self // Set Messaging delegate
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Method called when remote notification is received
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // Method to initialize PushKit
    func initializePushKit() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
    }
    
}

// Extension to handle PKPushRegistryDelegate methods
extension AppDelegate: PKPushRegistryDelegate{
    
    // MARK: PKPushRegistryDelegate
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        NSLog("pushRegistry:didUpdatePushCredentials:forType:")
        let token = credentials.token.map { String(format: "%02.2hhx", $0) }.joined()

        if let delegate = self.pushKitEventDelegate {
            delegate.credentialsUpdated(credentials: credentials)
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        NSLog("pushRegistry:didInvalidatePushTokenForType:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.credentialsInvalidated()
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.incomingPushReceived(payload: payload)
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:completion: \(payload.dictionaryPayload)")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.incomingPushReceived(payload: payload, completion: completion)
        }
        
        if let version = Float(UIDevice.current.systemVersion), version >= 13.0 {
            completion()
        }
    }
    
}


extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        UserDefaults.standard.setValue(fcmToken, forKey: UserDefaultsKeys.deviceToken)
        UserDefaults.standard.synchronize()
    }
    
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        completionHandler()
    }
}
