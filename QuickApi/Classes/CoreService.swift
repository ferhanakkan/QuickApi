//
//  CoreService.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 3.10.2020.
//

import Alamofire

class CoreService {
    
    private var baseApiUrl = Bundle.main.object(forInfoDictionaryKey: "ApiUrl") as! String
    private var endPoint: String = ""
    
    private let sessionManager: Session?
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 25
        configuration.timeoutIntervalForResource = 25
        sessionManager = Alamofire.Session(configuration: configuration)
    }
    
    func headers() -> HTTPHeaders {
        let userDefaults = UserDefaults.standard
        let headerLang = userDefaults.value(forKey: "langHeader") as? String ?? "en-US"

        if let token: String = UserDefaults.standard.value(forKey: Constants.Api.token) as? String {
                    print("request token Will delete in relase \(token)")
            return  ["Authorization": "Bearer \(token)",
                     "Content-Type" : "application/json",
                     "Accept-Language": headerLang]
        }
        
        return ["Authorization": "Bearer",
                "Content-Type" : "application/json",
                "Accept-Language": headerLang ]
        
        
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
//
//                        guard let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any] else{
////                            seal.reject(error)
//                            return
//                        }
//                        print("response test Will delete in relase\(json)")
                        
                        switch response.result {
                        case .success(let value):
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
                            
                            if let code = response.response?.statusCode {
                                if let errorString = CoreServiceErrorHandling().getError(json: json, statusCode: code) {
                                    let error = NSError(domain:"", code:code, userInfo:[ NSLocalizedDescriptionKey: errorString]) as Error
                                    seal.reject(error)
                                }
                            }
                            seal.reject(error)
                        }
                    } else {
                        print("response nil non value \(String(describing: response.error?.localizedDescription))")
                        seal.reject(response.error!)
                    }
                }
        }
        
        
    }
    
    //MARK: Multipart
    
    func upload<T:Decodable>(param:[String: Any], imageData: Data) -> Promise<T>  {
        return Promise<T>{ seal in
            let headers: HTTPHeaders
            headers = ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token")!)", "Content-Type" : "multipart/form-data"]
            
            AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
                multipart.append(imageData, withName: "upload[0]", fileName: "photo.jpg", mimeType: "image/jpeg")
                
            },to: "http://www.4mevsimapi.com/omr/upload/", usingThreshold: UInt64.init(),
            method: .post,
            headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable { (response: DataResponse<T, AFError>) in
                if response.data != nil {
                    switch response.result {
                    case .success(let value):
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
                        
                        if let code = response.response?.statusCode {
                            if let errorString = CoreServiceErrorHandling().getError(json: json, statusCode: code) {
                                let error = NSError(domain:"", code:code, userInfo:[ NSLocalizedDescriptionKey: errorString]) as Error
                                seal.reject(error)
                            }
                        }
                        seal.reject(error)
                    }
                } else {
                    seal.reject(response.error!)
                }

            }
        }
    }

    
    
    
    //MARK: - Actions
    
    func getPagination<T:Decodable>(url: String, page: Int = 0, size: Int = 20) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint, method: .get, parameters: ["page":page, "size": size])
    }
    
    func get<T: Decodable>(url: String, parameters : [String:Any]? = nil, anotherApi: String? = nil) -> Promise<T> {
        if let anotherUrl = anotherApi {
            endPoint = anotherUrl
        } else {
            endPoint = baseApiUrl+url
        }
        return self.request(fullUrl: endPoint , method: HTTPMethod.get , parameters : parameters)
    }
    
    func post<T: Decodable>(url: String, parameters: Parameters?) -> Promise<T>  {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.post , parameters : parameters)
    }
    
    func put<T: Decodable>(url: String, parameters: Parameters) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.put , parameters : parameters)
    }
    
    func patch<T: Decodable>(url: String, parameters: Parameters) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.patch , parameters : parameters)
    }
    
    func delete<T: Decodable>(url: String, parameters: Parameters? = nil) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.delete , parameters : parameters)
    }
    
}

