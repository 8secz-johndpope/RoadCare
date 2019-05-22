//
//  APIService.swift
//  Roadcare
//
//  Created by macbook on 4/22/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Alamofire

private let baseURL = "http://dev.skyconst.com/"
private let base_user = "admin"
private let base_password = "pass"

let APIClient = APIService(baseURL: baseURL)

class APIService {
    
    typealias CompletionHandler = (_ success: Bool, _ error: String?, _ data: Any?) -> Void
    
    let baseURL: String
    var manager : Alamofire.SessionManager!
    
    convenience init(baseURL: String) {
        self.init(baseURL: baseURL, backgroundMode: true)
    }
    
    init(baseURL: String, backgroundMode: Bool) {
        self.baseURL = baseURL
        
        let configuration = URLSessionConfiguration.default
        if (backgroundMode) {
            configuration.timeoutIntervalForRequest = 15
            configuration.timeoutIntervalForResource = 15
        } else {
            configuration.timeoutIntervalForRequest = 5
            configuration.timeoutIntervalForResource = 10
        }
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    private func get(path: String, params: [String: Any]? = nil, get_header: Bool = false, handler: @escaping CompletionHandler) -> DataRequest {
//        var headers = [String: String]()
//        if let token = AppConstants.authUser.token {
//            headers["x-auth-token"] = token
//            headers["requested-platform"] = "iOS"
//            headers["requested-app-version"] = AppVersion
//        }

        let user = base_user
        let password = base_password
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        var requestParams = params
        if requestParams == nil {
            requestParams = [String: Any]()
        }
        
        return manager.request(baseURL + path, parameters: requestParams, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if get_header {
                    if let headers = response.response?.allHeaderFields as? [String: String]{
                        let pages = headers["X-WP-TotalPages"]
                        handler(true, pages, data)
                    }
                } else {
                    handler(true, nil, data)
                }
            case .failure(let error):
                if let urlError = error as? URLError {
                    if urlError.code == URLError.Code.cancelled {
                        handler(false, ResponseCode.cancelled, nil)
                    } else {
                        handler(false, error.localizedDescription, nil)
                    }
                } else {
                    handler(false, error.localizedDescription, nil)
                }
            }
        }
    }
    
    private func post(path: String, params: [String: Any], encoding: ParameterEncoding = URLEncoding.default, responseString: Bool = false, handler: @escaping CompletionHandler) -> DataRequest {
//        var headers = [String: String]()
//        if let token = AppConstants.authUser.token {
//            headers["x-auth-token"] = token
//            headers["requested-platform"] = "iOS"
//            headers["requested-app-version"] = AppVersion
//        }

        let user = base_user
        let password = base_password
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        let request = manager.request(baseURL + path, method: .post, parameters: params, encoding: encoding, headers: headers)
        if responseString {
            return request.responseString(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    handler(true, nil, data)
                case .failure(let error):
                    if let urlError = error as? URLError {
                        if urlError.code == URLError.Code.cancelled {
                            handler(false, ResponseCode.cancelled, nil)
                        } else {
                            handler(false, error.localizedDescription, nil)
                        }
                    } else {
                        handler(false, error.localizedDescription, nil)
                    }
                }
            })
        } else {
            return request.responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    handler(true, nil, data)
                case .failure(let error):
                    if let urlError = error as? URLError {
                        if urlError.code == URLError.Code.cancelled {
                            handler(false, ResponseCode.cancelled, nil)
                        } else {
                            handler(false, error.localizedDescription, nil)
                        }
                    } else {
                        handler(false, error.localizedDescription, nil)
                    }
                }
            })
        }
    }
    
    private func delete(path: String, params: [String: Any], encoding: ParameterEncoding = URLEncoding.default, responseString: Bool = false, handler: @escaping CompletionHandler) -> DataRequest {
//        var headers = [String: String]()
//        if let token = AppConstants.authUser.token {
//            headers["x-auth-token"] = token
//            headers["requested-platform"] = "iOS"
//            headers["requested-app-version"] = AppVersion
//        }

        let user = base_user
        let password = base_password
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        let request = manager.request(baseURL + path, method: .delete, parameters: params, encoding: encoding, headers: headers)
        if responseString {
            return request.responseString(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    handler(true, nil, data)
                case .failure(let error):
                    if let urlError = error as? URLError {
                        if urlError.code == URLError.Code.cancelled {
                            handler(false, ResponseCode.cancelled, nil)
                        } else {
                            handler(false, error.localizedDescription, nil)
                        }
                    } else {
                        handler(false, error.localizedDescription, nil)
                    }
                }
            })
        } else {
            return request.responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    handler(true, nil, data)
                case .failure(let error):
                    if let urlError = error as? URLError {
                        if urlError.code == URLError.Code.cancelled {
                            handler(false, ResponseCode.cancelled, nil)
                        } else {
                            handler(false, error.localizedDescription, nil)
                        }
                    } else {
                        handler(false, error.localizedDescription, nil)
                    }
                }
            })
        }
    }
    
    private func requestWith(path: String, params: [String: Any], encoding: ParameterEncoding = URLEncoding.default, responseString: Bool = false, handler: @escaping CompletionHandler) -> DataRequest {
        let user = base_user
        let password = base_password
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials)",
            "Content-type": "multipart/form-data"
        ]
        
        let request = manager.request(baseURL + path, method: .post, parameters: params, encoding: encoding, headers: headers)
        if responseString {
            return request.responseString(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    handler(true, nil, data)
                case .failure(let error):
                    if let urlError = error as? URLError {
                        if urlError.code == URLError.Code.cancelled {
                            handler(false, ResponseCode.cancelled, nil)
                        } else {
                            handler(false, error.localizedDescription, nil)
                        }
                    } else {
                        handler(false, error.localizedDescription, nil)
                    }
                }
            })
        } else {
            return request.responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    handler(true, nil, data)
                case .failure(let error):
                    if let urlError = error as? URLError {
                        if urlError.code == URLError.Code.cancelled {
                            handler(false, ResponseCode.cancelled, nil)
                        } else {
                            handler(false, error.localizedDescription, nil)
                        }
                    } else {
                        handler(false, error.localizedDescription, nil)
                    }
                }
            })
        }
    }
    
    func register(username: String, email: String, password: String, role: String, city: String, country: String, phone: String, handler: @escaping CompletionHandler) -> DataRequest {
        let params: [String: Any] = [
            "username"  : username,
            "email"     : email,
            "password"  : password,
            "role"      : role,
            "city"      : city,
            "country"   : country,
            "phone"     : phone
        ]
        return post(path: "wp-json/wp/v2/users/register", params: params, encoding: JSONEncoding.default, responseString: false, handler: handler)
    }
    
    func addUser(username: String, email: String, password: String, handler: @escaping CompletionHandler) -> DataRequest {
        let params: [String: Any] = [
            "username"  : username,
            "email"     : email,
            "password"  : password
        ]
        return post(path: "wp-json/wp/v2/users/register", params: params, encoding: JSONEncoding.default, responseString: false, handler: handler)
    }
    
    func login(nonce: String, username: String, password: String, handler: @escaping CompletionHandler) -> DataRequest {
        let params: [String: Any] = [
            "nonce"     : nonce,
            "username"  : username,
            "password"  : password
        ]
        return get(path: "api/auth/generate_auth_cookie", params: params, handler: handler)
    }
    
    func getNonce(handler: @escaping CompletionHandler) -> DataRequest {
        let params: [String: Any] = [
            "controller" : "auth",
            "method"     : "generate_auth_cookie"
        ]
        return get(path: "api/get_nonce", params: params, handler: handler)
    }
    
    func getCategories(handler: @escaping CompletionHandler) -> DataRequest {
        let params: [String: Any] = [
            "per_page" : "100"
        ]
        return get(path: "wp-json/wp/v2/categories", params: params, handler: handler)
    }
    
    func addCategory(name: String, handler: @escaping CompletionHandler) -> DataRequest {
        let params: [String: Any] = [
            "name" : name
        ]
        return post(path: "wp-json/wp/v2/categories", params: params, encoding: JSONEncoding.default, responseString: false, handler: handler)
    }

    func reportPothole(params: PotholeDetails, handler: @escaping CompletionHandler) -> DataRequest {
        return post(path: "wp-json/wp/v2/posts", params: params.toDictionary(), encoding: JSONEncoding.default, responseString: false, handler: handler)
    }

    func updatePotholeLocation(id: Int, lat: String, lng: String, handler: @escaping CompletionHandler) -> DataRequest {
        let metaBox: [String: Any] = [
            "lat": lat,
            "lng": lng
        ]
        let params: [String: Any] = [
            "meta_box": metaBox
        ]
        return post(path: "wp-json/wp/v2/posts/" + String(id), params: params, encoding: JSONEncoding.default, responseString: false, handler: handler)
    }
    
    func updatePotholePhoto(id: Int, params: [String: Any], handler: @escaping CompletionHandler) -> DataRequest {
        return post(path: "wp-json/wp/v2/posts/" + String(id), params: params, encoding: JSONEncoding.default, responseString: false, handler: handler)
    }

    func uploadNewFile(file: String, handler: @escaping CompletionHandler) -> DataRequest {
        let params: [String: Any] = [
            "file": file
        ]
        return post(path: "wp-json/wp/v2/media", params: params, encoding: JSONEncoding.default, responseString: false, handler: handler)
    }
    
    func getPosts(page: String, handler: @escaping CompletionHandler) -> DataRequest {
        let params: [String: Any] = [
            "per_page" : "100",
            "page"     : page
        ]
        return get(path: "wp-json/wp/v2/posts", params: params, get_header: true, handler: handler)
    }
}
