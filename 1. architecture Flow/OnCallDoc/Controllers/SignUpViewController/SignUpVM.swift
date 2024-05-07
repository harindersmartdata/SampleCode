import Foundation
import UIKit

class SignUpVM: BaseViewModel {
    
    // MARK: Variables
    var controller : SignUpViewController?
    var userService: UserServiceProtocol
    
    // MARK: Initialization
    
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    // MARK: Validation Methods
    
    /*
     Method: signUp
     Functionality: Validates input and hit the api
     Return: true if input value is notvalid , otherwise hit the Login API
     */
    
    func signUp(firstName: String?, lastName: String?, email: String?, dob: String?, phoneNumber: String?, password: String?, gender: String?, ethnicity: String?, npi: String?, practiceAddress: String?, credentail: String?, suiteAddress: String?, state: String?, zipCode: String? , transcribeEmail: String?, completion:@escaping (SignUp) -> Void) {
        
        if !isInternetReachable() {
            self.errorMessage =   AlertMessage.lostInternet
            return
        }
        guard let fname = firstName, fname.count > 0 else {
            self.errorMessage = AlertMessage.Validations.firstNameEmpty
            return
        }
        guard let lname = lastName, lname.count > 0 else {
            self.errorMessage = AlertMessage.Validations.lastNameEmpty
            return
        }
        guard let dob = dob, dob.count > 0 else {
            self.errorMessage = AlertMessage.Validations.dobEmpty
            return
        }
        guard let gen = gender, gen.count > 0 else {
            self.errorMessage = AlertMessage.Validations.genderEmpty
            return
        }
        guard let ethn = ethnicity, ethn.count > 0 else {
            self.errorMessage = AlertMessage.Validations.ethinicityEmpty
            return
        }
        guard let npi = npi, npi.count > 0 else {
            self.errorMessage = AlertMessage.Validations.npiEmpty
            return
        }
        guard let address = practiceAddress, address.count > 0 else {
            self.errorMessage = AlertMessage.Validations.practiceAddressEmpty
            return
        }
        var suiteAdrs = ""
        if let suite = suiteAddress {
            suiteAdrs = suite
        }
        guard let stateN = state, stateN.count > 0 else {
            self.errorMessage = AlertMessage.Validations.stateEmpty
            return
        }
        guard let zip = zipCode, zip.count > 0 else {
            self.errorMessage = AlertMessage.Validations.zipEmpty
            return
        }
        guard let creds = credentail, creds.count > 0 else {
            self.errorMessage = AlertMessage.Validations.credentialEmpty
            return
        }
        guard var number = phoneNumber else {
            self.errorMessage =  AlertMessage.Validations.phoneNumberEmpty
            return
        }
        if !number.isValidPhoneNumber(){
            self.errorMessage =  AlertMessage.Validations.invalidPhoneNumber
            return
        }
        guard let mail = email, mail.isValidEmail() else {
            self.errorMessage = AlertMessage.Validations.invalidEmail
            return
        }
        guard let transMail = transcribeEmail, transMail.isValidEmail() else {
            self.errorMessage = AlertMessage.Validations.invalidEmailTrans
            return
        }
        
        guard let pswrd = password, pswrd.count > 0 else {
            self.errorMessage = AlertMessage.Validations.passwordEmpty
            return
        }
        if pswrd.count < 6{
            self.errorMessage = AlertMessage.Validations.passwordWeak
            return
        }
        
        let paramters = [
            Keys.firstName:fname,
            Keys.lastName: lname,
            Keys.dob: dob,
            Keys.gender: gen,
            Keys.ethnicity: ethn,
            Keys.npi: npi,
            Keys.practiceAddress: address,
            Keys.credentail: creds,
            Keys.phone: number,
            Keys.email: mail,
            Keys.transcribeEmail: transMail,
            Keys.password: pswrd,
            Keys.suiteAddress : suiteAdrs,
            Keys.state : stateN,
            Keys.zip : zip,
            Keys.deviceToken : deviceToken()
        ]
        
        let encryptedData = CryptoJSHelper.shared.dictionaryToEncryptedString(params: paramters)
        
        let encryptedParams = [Keys.encryptedData : encryptedData]
        
        self.signUpApi(encryptedParams as [String : Any]) { (user) in
            completion(user)
        }
    }
    
    // MARK: Api Methods
    /*
     Method: signUpApi
     Functionality: Hit the api and handles the response
     Return: NA
     */
    func signUpApi(_ params : [String:Any]?,
                   completion:@escaping (SignUp) -> Void) {
        self.isLoading = true
        userService.signUpApi(params){ (result) in
            switch result {
            case .success(let data):
                guard let user = data as? SignUp else { self.errorMessage = AlertMessage.Json.decodingError; return }
                
                if user.statusCode != success{
                    self.errorMessage = user.message
                    self.isLoading = false
                    return
                }
                
                completion(user)
                break
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
    
    func navigateToHome() {
        let storyboard = AppStoryboard.Main.instance
        let initialViewController = storyboard.instantiateViewController(withIdentifier: Controller.MainTab)
        let keyWindow = AppInstance().getKeyWindow()
        keyWindow?.rootViewController = initialViewController
        keyWindow?.makeKeyAndVisible()
    }
    
    
}

