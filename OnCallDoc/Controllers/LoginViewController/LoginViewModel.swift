import UIKit

class LoginViewModel: BaseViewModel {
    
    // MARK: Variables
    var controller : LoginViewController?
    var userService: UserServiceProtocol
    
    // MARK: Initialization
    
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func navigateToHome() {
        let storyboard = AppStoryboard.Main.instance
        let initialViewController = storyboard.instantiateViewController(withIdentifier: Controller.MainTab)
        let keyWindow = AppInstance().getKeyWindow()
        keyWindow?.rootViewController = initialViewController
        keyWindow?.makeKeyAndVisible()
    }
    
    // MARK: Validation Methods
    /*
     Method: isValidCredentials
     Functionality: Validates input with min limit and allowed char, valid domain
     Return: true if input value is allowed to be entred otherwise false
     */
    
    func isValidCredentials(email: String?, password: String?) -> (isValid: Bool, error: String?) {
        guard let mail = email, mail.isValidEmail() else {
            return (false, AlertMessage.Validations.invalidEmail)
        }
        guard let pswrd = password, pswrd.count > 0 else {
            return (false, AlertMessage.Validations.passwordEmpty)
        }
        if pswrd.count < MinLimit.password{
            return (false, AlertMessage.Validations.passwordWeak)
        }
        return (true, nil)
    }
    
    func isValidInput(_ textField: UITextField, string: String, range: NSRange) -> (Bool) {
        guard let email = controller?.txtFieldEmailAddress.text, let password = controller?.txtFieldPassword.text  else { return true }
        
        switch textField {
        case controller?.txtFieldEmailAddress:
            if  (string == "@" && range.location == 0){
                return false
            }
            return email.isInputValidForEmail(string)
        case controller?.txtFieldPassword:
            return password.isInputValidForPassword(string)
        default:
            break
        }
        return true
    }
    /*
     Method: login
     Functionality: Validates input and hit the api
     Return: true if input value is notvalid , otherwise hit the Login API
     */
    
    func login(withEmail email: String?, password: String? , completion:@escaping (UserData?) -> Void) {
        if !isInternetReachable() {
            self.errorMessage =   AlertMessage.lostInternet
            return
        }
        let validationTuple = isValidCredentials(email: email, password: password)
        guard validationTuple.isValid, let email = email, let password = password else {
            self.errorMessage = validationTuple.error
            return
        }
        self.loginApi(email, password: password) { (user) in
            completion(user)
        }
    }
    
    
    // MARK: Api Methods
    /*
     Method: loginApi
     Functionality: Hit the api and handles the response
     Return: NA
     */
    func loginApi(_ email: String, password: String,
                  completion:@escaping (UserData) -> Void) {
        self.isLoading = true
        userService.doLogin(email: email, password: password) { (result) in
            switch result {
            case .success(let data):
                guard let user = data as? UserData else { self.errorMessage = AlertMessage.Json.decodingError; return }
                if user.statusCode == success{
                    self.isLoading = false
                    completion(user)
                }else{
                    self.isLoading = false
                    self.isSuccess = false
                    self.errorMessage = user.message
                }
            case .error(let message):
                self.isLoading = false
                self.isSuccess = false
                self.errorMessage = message
                break
            case .customError(let errorModel):
                self.isLoading = false
                self.isSuccess = false
                self.errorMessage = errorModel.message
                break
            }
        }
    }
    
    
}
