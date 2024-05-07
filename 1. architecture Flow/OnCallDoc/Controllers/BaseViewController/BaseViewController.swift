import UIKit
import AVKit

class BaseViewController: UIViewController {
    
    var baseVwModel: BaseViewModel? {
        didSet {
            initBaseModel()
        }
    }
    
    var controller: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func hideNavigationBar(_ hide: Bool, animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(hide, animated: animated)
    }
    
    public func printLogs(_ string: String?)
    {
#if DEBUG
        print("\n Logs: \(string ?? "")")
#else
#endif
    }
    //
    func logout() {
        AppInstance.shared.userLoggedOut()
        
        let storyboard = AppStoryboard.Main.instance
        let initialViewController = storyboard.instantiateViewController(withIdentifier: Controller.MainNavigationController)
        let keyWindow = AppInstance().getKeyWindow()
        keyWindow?.rootViewController = initialViewController
        keyWindow?.makeKeyAndVisible()
    }
    
    // Cann't be override by subclass
    final func initBaseModel() {
        // Native binding
        baseVwModel?.showAlertClosure = { [weak self] (_ type:AlertType) in
            DispatchQueue.main.async {
                if type == .success, let message = self?.baseVwModel?.alertMessage {
                    let configAlert : AlertUI = ("", message)
                    UIAlertController.showAlert(configAlert)
                }else if type == .custom ,  let message = self?.baseVwModel?.alertMessage{
                    let configAlert : AlertUI = ("", message)
                    UIAlertController.showAlert(configAlert, sender: nil, actions: .OK) { (action) in
                    }
                }else if type == .error ,  let message = self?.baseVwModel?.errorMessage{
                    // Make Toast
                    let configAlert : AlertUI = ("", message)
                    UIAlertController.showAlert(configAlert, sender: nil, actions: .OK) { (action) in
                    }
                }else {
                    let message = self?.baseVwModel?.errorMessage ?? "Some Error occured"
                    let configAlert : AlertUI = ("", message)
                    UIAlertController.showAlert(configAlert)
                }
            }
        }
        baseVwModel?.updateLoadingStatus = { [weak self]()  in
            DispatchQueue.main.async {
                let isLoading = self?.baseVwModel?.isLoading ?? false
                ActivityIndicator.startSpinning(isLoading, text: self?.baseVwModel?.loaderText)
            }
        }
    }
    
    /// This method would execute when user switches from dark mode to light or Vice-versa.
    /// You can use this method in your view controller as well if you have different checks according to your requirments.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    
    func viewInNavStack(_ viewController: AnyClass) -> Bool {
        guard let viewArray = self.navigationController?.viewControllers else{ return false }
        for controller in viewArray as Array {
            if controller.isKind(of: viewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return true
            }
        }
        return false
    }
    
    func alertToAllowAccessViaSettings(target:UIViewController,message:String) {
        let alert = UIAlertController(title: kAppName, message: message, preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: AlertMessage.openSettings, style: .default) { alert in
            if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appSettingsURL as URL, options: [:], completionHandler: { (result) in})
                } else {UIApplication.shared.openURL(appSettingsURL as URL)}
            }
        })
        alert.addAction(UIAlertAction(title: Cancel, style: .cancel) { alert in})
        target.present(alert, animated: true, completion: nil)
    }
}


