import UIKit
import AVFoundation

struct PlatformUtils {
    static let isSimulator: Bool = {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }()
}

class ImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate {
    
    typealias AuthorizationCompletion = (AVAuthorizationStatus?) -> Void
    
    func showOptionAlert(viewController: UIViewController, completion: @escaping AuthorizationCompletion) {
        let alertController = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.requestCameraAuthorization(completion: completion, presentingViewController: viewController)
        }
        alertController.addAction(cameraAction)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openPhotoLibrary(viewController: viewController)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        }
        alertController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.sourceView = viewController.view
                popoverPresentationController.sourceRect = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 320)
            }
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    private func requestCameraAuthorization(completion: @escaping AuthorizationCompletion, presentingViewController: UIViewController) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            if !PlatformUtils.isSimulator {
                openCamera(viewController: presentingViewController)
            }
            completion(.authorized)
        case .denied:
            completion(.denied)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { accessGranted in
                if accessGranted {
                    self.openCamera(viewController: presentingViewController)
                }
                completion(accessGranted ? .authorized : nil)
            }
        case .restricted:
            completion(.restricted)
        @unknown default:
            completion(nil)
        }
    }
    
    private func openPhotoLibrary(viewController: UIViewController) {
        self.sourceType = .photoLibrary
        self.modalPresentationStyle = .popover
        presentImagePicker(viewController: viewController)
    }
    
    private func openCamera(viewController: UIViewController) {
        self.sourceType = .camera
        self.modalPresentationStyle = .popover
        presentImagePicker(viewController: viewController)
    }
    
    private func presentImagePicker(viewController: UIViewController) {
        DispatchQueue.main.async {
            if let popoverPresentationController = self.popoverPresentationController, UIDevice.current.userInterfaceIdiom == .pad {
                popoverPresentationController.sourceView = viewController.view
                popoverPresentationController.sourceRect = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }
            viewController.present(self, animated: true, completion: nil)
        }
    }
}

