/*
 Copyright (c) 2018 smartData
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import UIKit

let success = 200
let timeOut = 30.0
let successResponse = "200"

public enum HttpMethod: String {
    case POST
    case GET
    case PUT
    case DELETE
}

private enum ResponseCode: Int {
    case success = 200
    case notFound = 404
    case tokenExpire = 401
}

struct File {
    let name: String?
    let filename: String?
    let data: Data?
    init(name: String?,filename: String?, data: Data?) {
        self.name = name
        self.filename = filename
        self.data = data
    }
}

enum Result <T>{
    case success(T)
    case error(String)
    case customError(ErrorBase)
}

public struct Service {
    //We are creating a tuple for HTTP Method and Service URL to avoid the parameters confusion in functions
    typealias config = (method:HttpMethod, path:String)
}


protocol ApiServiceProtocol {
    func startService<T: Decodable>(config: Service.config, parameters:[String:Any]?, files:[File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void)
    func startQueryService<T: Decodable>(config: Service.config, parameters:[String:Any]?, files:[File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void)
    func startMultipartService<T: Decodable>(config: Service.config, parameters:[String:Any]?, files:[File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void)
    func buildRequest(with method:HttpMethod, url:URL, parameters:[String:Any]?, files:[File]?) -> URLRequest
    func buildParams(parameters: [String:Any]) -> String
    func handleResponse<T: Decodable>(data: Data, response:URLResponse?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void)
    func sendQueryRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void)
}

public class APIService: NSObject, ApiServiceProtocol {
    
    /// Start the Service
    /// - Parameter config:We are defining the HTTP method and the server URL in a tuple
    /// - Parameter parameters: parameters which needs to be send on server while hitting the api
    /// - Parameter files: Multimedia Files which may contain images or videos to be uploaded to server.
    /// - Parameter modelType: Get response in Model after serialization the response from server
    /// - Parameter completion: Call back to update the ViewModel
    func startService<T: Decodable>(config: Service.config, parameters:[String:Any]?, files:[File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void) {
        
        if !isInternetReachable() {
            completion(.error(AlertMessage.lostInternet))
            return
        }
        
        guard let url = URL(string: BaseUrl + Path.controller + config.path) else { return completion(.error(AlertMessage.invalidURL)) }
        printLogs("\n API URL : \(url) \n API METHOD : \n \(config) \n REQUEST : \n \(parameters?.description ?? "No Paramaters")")
        let request = self.buildRequest(with: config.method, url: url, parameters: parameters, files: files)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.error(error!.localizedDescription)) }
            guard let data = data else { return completion(.error(error?.localizedDescription ?? AlertMessage.lostInternet))
            }
            self.handleResponse(data: data, response: response, modelType: modelType, completion: completion)
        }
        task.resume()
    }
    
    func garminStartService<T: Decodable>(config: Service.config, parameters:[String:Any]?, files:[File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void) {
        
        if !isInternetReachable() {
            completion(.error(AlertMessage.lostInternet))
            return
        }
        
        guard let url = URL(string: BaseUrl + Path.controller + config.path) else { return completion(.error(AlertMessage.invalidURL)) }
        printLogs("\n API URL : \(url) \n API METHOD : \n \(config) \n REQUEST : \n \(parameters?.description ?? "No Paramaters")")
        let request = self.buildRequest(with: config.method, url: url, parameters: parameters, files: files)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.error(error!.localizedDescription)) }
            guard let data = data else { return completion(.error(error?.localizedDescription ?? AlertMessage.lostInternet))
            }
            self.handleResponse(data: data, response: response, modelType: modelType, completion: completion)
        }
        task.resume()
    }
    
    func startQueryService<T: Decodable>(config: Service.config, parameters:[String:Any]?, files:[File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void) {
        
        if !isInternetReachable() {
            completion(.error(AlertMessage.lostInternet))
            return
        }
        var components = URLComponents(string: BaseUrl + Path.controller + config.path)!
        components.queryItems = parameters?.map({ (key, value) -> URLQueryItem in
            URLQueryItem(name: key, value: value as? String)
        })
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        if let token = userToken() {
            printLogs("\n Token: \(token)")
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        printLogs("\n Query API METHOD : \n \(config) \n REQUEST : \n \(parameters?.description ?? "No Paramaters")")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.error(error!.localizedDescription)) }
            guard let data = data else { return completion(.error(error?.localizedDescription ?? AlertMessage.lostInternet))
            }
            
            self.handleResponse(data: data, response: response, modelType: modelType, completion: completion)
        }
        task.resume()
    }
    
    func startMultipartService<T: Decodable>(config: Service.config, parameters:[String:Any]?, files:[File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void) {
        if !isInternetReachable() {
            completion(.error(AlertMessage.lostInternet))
            return
        }
        
        guard let url = URL(string: BaseUrl + Path.controller + config.path) else { return completion(.error(AlertMessage.invalidURL)) }
        
        //        let request = self.buildRequestForMultiMedia(url, multimediaFiles: files, parameters: parameters)
        let request = self.buildRequest(with: .POST, url: url, parameters: parameters, files: files)
        
        printLogs("\n Multipart API METHOD : \n \(config) \n REQUEST : \n \(parameters?.description ?? "No Paramaters")")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.error(error?.localizedDescription ?? AlertMessage.lostInternet)) }
            guard let data = data else { return completion(.error(error?.localizedDescription ?? AlertMessage.lostInternet))
            }
            self.handleResponse(data: data, response: response, modelType: modelType, completion: completion)
        }
        task.resume()
    }
    
}

extension APIService {
    /// Building the request for Services
    /// - Parameter method: to indicate the desired action to be performed on Server.
    /// - Parameter url: Api URL
    /// - Parameter parameters: parameters which needs to send server along with the api
    /// - Parameter files: Multimedia Files which needs to send server along with the api
    func buildRequest(with method:HttpMethod, url:URL, parameters:[String: Any]?, files:[File]?) -> URLRequest {
        
        var request:URLRequest?
        switch method {
        case .GET:
            if let params = parameters,params.count > 0 {
                var string = url.absoluteString
                string.append("\("?"+buildParams(parameters: params))")
                //let queryUrl = url.appendingPathComponent("?"+buildParams(parameters: params))
                if let queryUrl = URL(string: string) {
                    print(queryUrl)
                    request = URLRequest(url: queryUrl)
                }
            } else {
                request = URLRequest(url: url)
            }
            request?.timeoutInterval = timeOut
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .POST,.PUT:
            request = self.buildRequestForMultiMedia(url, multimediaFiles: files, parameters: parameters)
        case .DELETE:
            request = self.buildRequestForMultiMedia(url, multimediaFiles: files, parameters: parameters)
            break
        }
        //        var req = request ?? URLRequest(url: url)
        
        // pass your authorisation token here.
        // it can be saved in nsuserdefaaults or in singelton
        if let token = userToken() {
            printLogs("\n Token: \(token)")
            //          if token.count > 0
            //          {
            request?.addValue(token, forHTTPHeaderField: "Authorization")
            //          }
        }
        request?.httpMethod = method.rawValue
        return request ?? URLRequest(url: url)
    }
    
    func sendQueryRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                            // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error, otherwise ...
                      completion(nil, error)
                      return
                  }
            if let token = userToken() {
                printLogs("\n Token: \(token)")
                request.addValue(token, forHTTPHeaderField: "Authorization")
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    func buildRequestForMultiMedia(_ serviceURL:URL, multimediaFiles:[File]?, parameters:[String: Any]?) -> URLRequest {
        var uploadRequest = URLRequest(url: serviceURL)
        uploadRequest.timeoutInterval = timeOut
        if let images = multimediaFiles, images.count > 0 {
            
            let boundary = "Boundary-\(UUID().uuidString)"
            let boundaryPrefix = "--\(boundary)\r\n"
            let boundarySuffix = "--\(boundary)--\r\n"
            
            uploadRequest.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
            let data = NSMutableData()
            if let params = parameters, params.count > 0 {
                for (key, value) in params {
                    if let subprm = value as? [String:Any] {
                        let subdata = NSMutableData()
                        for (key, value) in subprm {
                            subdata.append("--\(boundary)\r\n".nsdata)
                            subdata.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                            subdata.append("\((value as AnyObject).description ?? "")\r\n".nsdata)
                        }
                        data.append("--\(boundary)\r\n".nsdata)
                        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                        data.append(subdata as Data)
                    }
                    else
                    {
                        data.append("--\(boundary)\r\n".nsdata)
                        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                        data.append("\((value as AnyObject).description ?? "")\r\n".nsdata)
                    }
                }
            }
            
            for file in images {
                data.append(boundaryPrefix.nsdata)
                data.append("Content-Disposition: form-data; name=\"\(file.name!)\"; filename=\"\(NSString(string: file.filename!))\"\r\n\r\n".nsdata)
                if let imgData = file.data {
                    data.append(imgData)
                    data.append("\r\n".nsdata)
                } else {
                    printLogs("Could not read file data")
                }
            }
            data.append(boundarySuffix.nsdata)
            uploadRequest.httpBody = data as Data
        } else if let params = parameters,params.count > 0 {
            uploadRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let  jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            uploadRequest.httpBody = jsonData
        }
        return uploadRequest
    }
    
    func buildParams(parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for (key,value) in parameters {
            components += self.queryComponents(key, value)
        }
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    
    func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append(contentsOf: [(escape(string: key), escape(string: "\(value)"))])
        }
        
        return components
    }
    
    func escape(string: String) -> String {
        if let encodedString = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
            return encodedString
        }
        return ""
    }
}

extension APIService {
    func handleResponse<T: Decodable>(data: Data, response:URLResponse?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void) {
        /*let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
         
         printLogs("\n STATUS CODE = \(statusCode)")
         let responseString: String = String(data: data, encoding: String.Encoding.utf8) ?? ""
         printLogs("\n RESPONSE = \(responseString)")
         // TODO: Update this if your server update HttpResponse code in case of error
         if statusCode == ResponseCode.success.rawValue {
         do {
         // 1
         let decoder = JSONDecoder()
         let genericModel = try decoder.decode(modelType, from: data)
         completion(.success(genericModel))
         } catch let error {
         completion(.error(error.localizedDescription))
         }
         } else {
         completion(.error("Error message: \(statusCode)"))
         }
         }
         }*/
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        printLogs("\n STATUS CODE = \(statusCode)")
        let responseString: String = String(data: data, encoding: String.Encoding.utf8) ?? ""
        printLogs("\n RESPONSE = \(responseString)")
        // TODO: Update this if your server update HttpResponse code in case of error
        switch statusCode {
        case 200 ... 299:
            do {
                let genericModel = try JSONDecoder().decode(modelType, from: data)
                completion(.success(genericModel))
            } catch let error {
                completion(.error(error.localizedDescription))
            }
        case 400 ... 499:
            if statusCode == 403 {
                DispatchQueue.main.async {
                    // user token has been expired
                    //           let configAlert: AlertUI = ("", AlertMessage.sessionExpire)
                    //           UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.OK) { (onResponse) in
                    //            AppInstance.setLogin()
                    if let vc = UIApplication.topViewController() as? BaseViewController {
                        vc.logout()
                    }else  if let tab = UIApplication.topViewController() as? UITabBarController {
                        if let nav = tab.selectedViewController as? UINavigationController{
                            if let vc = nav.topViewController as? BaseViewController{
                                do {
                                    let genericModel = try JSONDecoder().decode(ErrorBase.self, from: data)
                                    vc.baseVwModel?.errorMessage = genericModel.message
                                    completion(.customError(genericModel))
                                } catch let error {
                                    completion(.error(error.localizedDescription))
                                }
                                vc.logout()
                            }
                        }
                    }
                }
            } else {
                do {
                    let genericModel = try JSONDecoder().decode(ErrorBase.self, from: data)
                    completion(.customError(genericModel))
                } catch let error {
                    completion(.error(error.localizedDescription))
                }
            }
        default:
            
            do {
                let genericModel = try JSONDecoder().decode(ErrorBase.self, from: data)
                if let msg = genericModel.message{
                    completion(.error(msg))
                }else{
                    completion(.error(AlertMessage.somethingWentWrong))
                }
                
            } catch let error {
                completion(.error(error.localizedDescription))
            }
            
            
        }
    }
}

