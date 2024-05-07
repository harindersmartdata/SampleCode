import UIKit
import SkyFloatingLabelTextField

class LoginViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet weak var txtFieldEmailAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFieldPassword: SkyFloatingLabelTextField!
    
    
    // MARK: Variables
    
    lazy var viewModel: LoginViewModel = {
        let obj = LoginViewModel(userService: UserService())
        self.baseVwModel = obj
        obj.controller = self
        return obj
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
 
    func initialSetup(){
        txtFieldEmailAddress.delegate = self
        txtFieldPassword.delegate = self
        txtFieldPassword.enablePasswordToggle()
    }
    
    // MARK: Button Actions
    @IBAction func buttonActionSignUp(_ sender: Any) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: Controller.SignUp) as! SignUpViewController
        if !self.viewInNavStack(SignUpViewController.self){
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonActionForgotPassword(_ sender: Any) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: Controller.ForgotPassword) as! ForgotPasswordViewController
        if !self.viewInNavStack(ForgotPasswordViewController.self){
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonActionLogin(_ sender: Any) {
        view.endEditing(true)
        viewModel.login(withEmail: txtFieldEmailAddress.text, password: txtFieldPassword.text) { (user) in
            self.viewModel.isLoading = false
            
            let dataDict = CryptoJSHelper.shared.encryptedStringToDic(encryptedData: user?.data ?? "")
            
            
            if let token = dataDict?[Keys.token] as? String{
                UserDefaults.standard.setValue(token, forKey: UserDefaultsKeys.token)
            }
            if let userdata = dataDict?["userdata"] as? NSDictionary{
                if let email = userdata[Keys.email] as? String,
                   let id = userdata["id"] as? String{
                    UserDefaults.standard.setValue(email, forKey: UserDefaultsKeys.userEmail)
                    UserDefaults.standard.setValue(id, forKey: UserDefaultsKeys.userID)
                    UserDefaults.standard.synchronize()
                }
                if let twilioNumber = userdata["twilioNumber"] as? String{
                    UserDefaults.standard.setValue(twilioNumber, forKey: UserDefaultsKeys.onCallNumber)
                }
                
            }
            self.viewModel.navigateToHome()
        }
    }
    
    
}

extension LoginViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let email = txtFieldEmailAddress.text, let password = txtFieldPassword.text else { return true }
        if string == ""{
            return true
        }
        if (string == " " && range.location == 0){
            return false
        }
        switch textField {
        case txtFieldEmailAddress:
            if (string == "@" && range.location == 0){
                return false
            }
            return email.isInputValidForEmail(string)
        case txtFieldPassword:
            return password.isInputValidForPassword(string)
        default:
            break
        }
        return true
    }
    
}

