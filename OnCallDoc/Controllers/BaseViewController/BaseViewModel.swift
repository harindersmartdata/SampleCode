import UIKit

enum AlertType {
    case normal
    case warning
    case error
    case success
    case custom  
}

class BaseViewModel: NSObject {
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var loaderText: String? {
        didSet {
            self.setLoaderText?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?(.success)
        }
    }
    
    var customAertMessage: String? {
        didSet {
            self.showAlertClosure?(.custom)
        }
    }
    
    var pushOnSuccessAlert: String? {
        didSet {
            self.navigateOnSuccessAlert?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    
    var isSuccess:Bool? {
        didSet {
            if isSuccess ?? false {
                self.redirectControllerClosure?()
            }
        }
    }
    
    var isFailed:Bool? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    
    var previousView: UIViewController? {
        didSet {
            self.previousViewController?()
        }
    }
    
    var showAlertClosure: ((_ type: AlertType)->Void)?
    var navigateOnSuccessAlert: (()->Void)?
    var updateLoadingStatus: (()->Void)?
    var previousViewController: (()->Void)?
    var reloadListViewClosure: (()->Void)?
    var redirectControllerClosure: (()->Void)?
    var setCameraOrientaion : (()->Void)?
    var setLoaderText : (()->Void)?
    
    
}
