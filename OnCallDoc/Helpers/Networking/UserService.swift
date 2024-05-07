import Foundation
import UIKit

protocol UserServiceProtocol {
    func doLogin(email: String, password:String, completion:@escaping (Result<Any>) -> Void)
    func logoutUser(params: [String:Any], completion:@escaping (Result<Any>) -> Void)
    func signUpApi(_ parametrs: [String:Any]?, completion:@escaping (Result<Any>) -> Void)
}

public class UserService: APIService, UserServiceProtocol {
    
    
    func doLogin(email: String, password:String, completion:@escaping (Result<Any>) -> Void) {
        
        let parameters = [Keys.email:email, Keys.password : password, Keys.deviceToken : deviceToken()]
        
        let encryptedData = CryptoJSHelper.shared.dictionaryToEncryptedString(params: parameters)
        let encryptedParams = [Keys.encryptedData : encryptedData]
        
        let serviceConfig : Service.config = (.POST, APIName.login)
        super.startService(config: serviceConfig, parameters: encryptedParams as [String : Any], files: nil, modelType: UserData.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let model = data {
                        completion(.success(model))
                    }
                    break
                case .error(let message):
                    completion(.error(message))
                    break
                case .customError(let errorModel):
                    completion(.customError(errorModel))
                    break
                }
            }
        }
    }
    
    func logoutUser(params: [String : Any], completion:@escaping (Result<Any>) -> Void) {
        let serviceConfig : Service.config = (.POST, APIName.logOut)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: UserData.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let userModel = data {
                        completion(.success(userModel))
                    }
                case .error(let message):
                    completion(.error(message))
                    break
                case .customError(let errorModel):
                    completion(.customError(errorModel))
                    break
                }
            }
        }
    }
    
    func signUpApi(_ parametrs: [String:Any]?, completion:@escaping (Result<Any>) -> Void){
        let serviceConfig : Service.config = (.POST, APIName.Signup)
        super.startService(config: serviceConfig, parameters: parametrs, files: nil, modelType: SignUp.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let userModel = data {
                        completion(.success(userModel))
                    }
                case .error(let message):
                    completion(.error(message))
                    break
                case .customError(let errorModel):
                    completion(.customError(errorModel))
                    break
                }
            }
        }
    }
}

