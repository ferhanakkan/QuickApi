//
//  CoreService.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 3.10.2020.
//

import Alamofire
import PromiseKit

public class Quick {
    
    public static var shared = Quick()

    public var timeOutTime = 0 {
        didSet {
            configuration.timeoutIntervalForRequest = Double(timeOutTime)
            configuration.timeoutIntervalForResource = Double(timeOutTime)
            sessionManager = Alamofire.Session(configuration: configuration)
        }
    }
    
    public var errorModel = ErrorHandling()
    public var acceptLanguageCode = ""
    public var showResponseJSONOnConsole = false
    public var customErrorModel = false
    public var showLoadingIndicator = false
    public var showAlertMessageInError = false
    public var messageTitle = "Error"
    public var buttonTitle = "Ok"
    
    private var endPoint: String = ""
    private var baseApiUrl = ""
    private var multiPartUrl = ""
    private var responseJson: Any?
    
    private var sessionManager: Session?
    private let configuration = URLSessionConfiguration.default

    public init() {
        
        if let preSelectedLanguage = UserDefaults.standard.value(forKey: "langCodeFA") as? String {
            acceptLanguageCode = preSelectedLanguage
        }
    }

    //MARK: Completion Converter
    
    public func getRequest<T: Decodable>(endPoint: String, parameters: [String:Any]? = nil, responseObject: T.Type ,completion: @escaping (T?,Any, Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.get(url: endPoint, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, self.responseJson, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, self.responseJson, err)
        }
    }
    
    public func getRequest<T: Decodable>(endPoint: String, parameters: [String:Any]? = nil, responseObject: T.Type ,completion: @escaping (T?, Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.get(url: endPoint, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, err)
        }
    }
    
    public func getPaginationRequest<T: Decodable>(endPoint: String, page: Int, size: Int, responseObject: T.Type ,completion: @escaping (T?,Any, Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.getPagination(url: endPoint, page: page, size: size, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, self.responseJson, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, self.responseJson, err)
        }
    }
    
    public func getPaginationRequest<T: Decodable>(endPoint: String, page: Int = 0, size: Int = 20, responseObject: T.Type ,completion: @escaping (T?, Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.getPagination(url: endPoint, page: page, size: size, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, err)
        }
    }
    
    
    public func postRequest<T: Decodable>(url: String, parameters: Parameters?, responseObject: T.Type ,completion: @escaping (T?,Any , Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.post(url: url, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, self.responseJson, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, self.responseJson, err)
        }
    }

    public func postRequest<T: Decodable>(url: String, parameters: Parameters?, responseObject: T.Type ,completion: @escaping (T?,Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.post(url: url, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, err)
        }
    }
    
    public func putRequest<T: Decodable>(url: String, parameters: Parameters?, responseObject: T.Type ,completion: @escaping (T?, Any , Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.put(url: url, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, self.responseJson, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, self.responseJson, err)
        }
    }

    public func putRequest<T: Decodable>(url: String, parameters: Parameters?, responseObject: T.Type ,completion: @escaping (T?,Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.put(url: url, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, err)
        }
    }
    
    public func patchRequest<T: Decodable>(url: String, parameters: Parameters?, responseObject: T.Type ,completion: @escaping (T?,Any , Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.patch(url: url, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, self.responseJson, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, self.responseJson, err)
        }
    }

    public func patchRequest<T: Decodable>(url: String, parameters: Parameters?, responseObject: T.Type ,completion: @escaping (T?,Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.patch(url: url, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, err)
        }
    }
    
    public func deleteRequest<T: Decodable>(url: String, parameters: Parameters?, responseObject: T.Type ,completion: @escaping (T?,Any, Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.delete(url: url, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, self.responseJson, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, self.responseJson, err)
        }
    }

    public func deleteRequest<T: Decodable>(url: String, parameters: Parameters?, responseObject: T.Type ,completion: @escaping (T?,Error?) -> ()) {
        showLoadingIndicator ? LoadingView.show() : nil
        self.delete(url: url, parameters: parameters, decodeObject: responseObject).done { (res) in
            LoadingView.hide()
            completion(res, nil)
        }.catch { (err) in
            LoadingView.hide()
            completion(nil, err)
        }
    }
    
    
    //MARK: Logic
    
    public func clearToken() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(nil, forKey: Constants.token)
    }
    
    public func setToken(token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(token, forKey: Constants.token)
    }

    public func setAcceptlanguage(code: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(code, forKey: Constants.langCode)
    }
    
    public func clearAcceptLanguage() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(nil, forKey: Constants.langCode)
    }
    
    public func setApiBaseUrl(url: String) {
        baseApiUrl = url
    }
    
    public func setMultipartApiUrl(url: String) {
        multiPartUrl = url
    }
    
    
    
    //MARK: Header
    
    private func headers() -> HTTPHeaders {

        if let token: String = UserDefaults.standard.value(forKey: Constants.token) as? String {
            if acceptLanguageCode != "" {
                return  ["Authorization": "Bearer \(token)",
                         "Content-Type" : "application/json",
                         "Accept-Language": acceptLanguageCode]
            } else {
                return  ["Authorization": "Bearer \(token)",
                         "Content-Type" : "application/json"]
            }
        }
        
        if acceptLanguageCode != "" {
            return ["Content-Type" : "application/json",
                    "Accept-Language": acceptLanguageCode ]
        } else {
            return ["Content-Type" : "application/json"]
        }
        
    }
    
    //MARK: - Request
    
    @discardableResult
    public func request<T:Decodable>(fullUrl url: String,method: HTTPMethod, parameters: Parameters?) -> Promise<T> {

        
        var encodinga: ParameterEncoding? = nil
        if(method != .get) {
            encodinga = JSONEncoding.default
        } else {
            encodinga = URLEncoding.queryString
        }
      
                
        return Promise<T> { seal in
            sessionManager!.request(url, method: method, parameters: parameters, encoding: encodinga!, headers: headers())
                .validate(statusCode: 200..<300)
                .responseDecodable { (response: DataResponse<T, AFError>) in
                    if response.data != nil {
                        switch response.result {
                        case .success(let value):
                            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]  {
                                self.responseJson = json
                                if self.showResponseJSONOnConsole {
                                    print("QuickApi response : \(json)")
                                }
                            }
                            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [[String: Any]]  {
                                self.responseJson = json
                                if self.showResponseJSONOnConsole {
                                    print("QuickApi response : \(json)")
                                }
                            }
                            seal.fulfill(value)
                        case .failure(let error):
                            guard let data = response.data else {
                                seal.reject(error)
                                return
                            }
                            
                            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
                                seal.reject(error)
                                return
                            }
                            
                            self.responseJson = json
                            if self.showResponseJSONOnConsole {
                                print("QuickApi response : \(json)")
                            }
                            
                            if self.customErrorModel {
                                if let code = response.response?.statusCode {
                                    if let errorString = ErrorHandling().getError(json: json, statusCode: code) {
                                        let error = NSError(domain:"", code:code, userInfo:[ NSLocalizedDescriptionKey: errorString]) as Error
                                        if self.showAlertMessageInError {
                                            let action = UIAlertAction(title: self.buttonTitle, style: .default) { (_) in
                                            }
                                            AlertMessage.messagePresent(title: self.messageTitle, message: error.localizedDescription, moreButtonAction: nil, firstAlertAction: action)
                                        }
                                        seal.reject(error)
                                    }
                                }
                            }
                            seal.reject(error)
                        }
                    } else {
                        print("QuickApi response nil \(String(describing: response.error?.localizedDescription))")
                        seal.reject(response.error!)
                    }
                }
        }
        
        
    }
    
    //MARK: Multipart
    
    private func upload<T:Decodable>(endPoint url: String, param:[String: Any], data: [Data],responseObject: T.Type) -> Promise<T>  {
        return Promise<T>{ seal in
            endPoint = multiPartUrl+url
            let headers: HTTPHeaders
            if let token = UserDefaults.standard.string(forKey: Constants.token) {
                headers = ["Authorization": "Bearer \(token)", "Content-Type" : "multipart/form-data"]
            } else {
                headers = ["Content-Type" : "multipart/form-data"]
            }
            
            AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
                
                for selectedData in data {
                    multipart.append(selectedData, withName: "upload[0]", fileName: "photo.jpg", mimeType: "image/jpeg")
                }
                
            },to: multiPartUrl , usingThreshold: UInt64.init(),
            method: .post,
            headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable { (response: DataResponse<T, AFError>) in
                if response.data != nil {
                    switch response.result {
                    case .success(let value):
                        guard let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any] else {
                            return
                        }
                        self.responseJson = json
                        if self.showResponseJSONOnConsole {
                            print("QuickApi response : \(json)")
                        }
                        seal.fulfill(value)
                    case .failure(let error):
                        guard let data = response.data else {
                            seal.reject(error)
                            return
                        }
                        
                        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            seal.reject(error)
                            return
                        }
                        self.responseJson = json
                        if self.showResponseJSONOnConsole {
                            print("QuickApi response : \(json)")
                        }
                        
                        if self.customErrorModel {
                            if let code = response.response?.statusCode {
                                if let errorString = ErrorHandling().getError(json: json, statusCode: code) {
                                    let error = NSError(domain:"", code:code, userInfo:[ NSLocalizedDescriptionKey: errorString]) as Error
                                    if self.showAlertMessageInError {
                                        let action = UIAlertAction(title: self.buttonTitle, style: .default) { (_) in
                                        }
                                        AlertMessage.messagePresent(title: self.messageTitle, message: error.localizedDescription, moreButtonAction: nil, firstAlertAction: action)
                                    }
                                    seal.reject(error)
                                }
                            }
                        }
                        if self.showAlertMessageInError {
                            let action = UIAlertAction(title: self.buttonTitle, style: .default) { (_) in
                            }
                            AlertMessage.messagePresent(title: self.messageTitle, message: error.localizedDescription, moreButtonAction: nil, firstAlertAction: action)
                        }

                        seal.reject(error)
                    }
                    print("QuickApi response nil \(String(describing: response.error?.localizedDescription))")
                } else {
                    print("QuickApi response nil \(String(describing: response.error?.localizedDescription))")
                    if self.showAlertMessageInError {
                        let action = UIAlertAction(title: self.buttonTitle, style: .default) { (_) in
                        }
                        AlertMessage.messagePresent(title: self.messageTitle, message: response.error!.localizedDescription, moreButtonAction: nil, firstAlertAction: action)
                    }
                    
                    seal.reject(response.error!)
                }

            }
        }
    }

    
    
    
    //MARK: - Actions
    
    private func getPagination<T:Decodable>(url: String, page: Int, size: Int, decodeObject: T.Type) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint, method: .get, parameters: ["page":page, "size": size])
    }
    
    private func get<T: Decodable>(url: String, parameters : [String:Any]? = nil, decodeObject: T.Type) -> Promise<T> {
            endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.get , parameters : parameters)
    }
    
    private func post<T: Decodable>(url: String, parameters: Parameters?, decodeObject: T.Type) -> Promise<T>  {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.post , parameters : parameters)
    }
    
    private func put<T: Decodable>(url: String, parameters: Parameters?, decodeObject: T.Type) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.put , parameters : parameters)
    }
    
    private func patch<T: Decodable>(url: String, parameters: Parameters?, decodeObject: T.Type) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.patch , parameters : parameters)
    }
    
    private func delete<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.delete , parameters : parameters)
    }
    
}

