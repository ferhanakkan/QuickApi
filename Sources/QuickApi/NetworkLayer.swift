//
//  NetworkLayer.swift
//  
//
//  Created by Ferhan Akkan on 27.09.2021.
//


#if os(iOS)

import Alamofire
import Foundation

final class NetworkLayer {
  
  private let configuration = URLSessionConfiguration.default
  private var sessionManager: Session?
  
  #warning("Repeat eklenecek")
  
  /// This parameter sets requests time out.
  private var requestTimeOut = 0 {
    didSet {
      if requestTimeOut < 1 { requestTimeOut = 1 }
      configuration.timeoutIntervalForRequest = Double(requestTimeOut)
      configuration.timeoutIntervalForResource = Double(requestTimeOut)
      sessionManager = Alamofire.Session(configuration: configuration)
    }
  }
  
  private var baseApiUrl: String?
  private var endPoint: String?
  
  private var customHttpHeader: HTTPHeaders?
  private var languageCode: String?
  private var showResponseInConsole: Bool = false
  
  private var customErrorModel: Bool = false
  
  init() {
    getCustomHttpHeader()
  }
}


// MARK: - Network For Requests

extension NetworkLayer {
  
  public func request<T: Decodable>(fullUrl: String,
                                    method: HTTPMethod,
                                    parameters: Parameters?,
                                    decodeObject: T.Type,
                                    completion: @escaping GenericCompletion<T>) {
    
    let encodingType = getEncodingType(method: method)
    let httpHeader = getHeader()
    
    guard let sessionManager = sessionManager else {
      print("Session Manager Issue detected.")
      return
    }
    
    sessionManager
      .request(fullUrl, method: method, parameters: parameters, encoding: encodingType, headers: httpHeader)
      .validate(statusCode: 200..<300)
      .responseJSON { [weak self] response in
        
        self?.showJsonResponse(response.data)
        
        switch response.result {
        case .success(let data):
          break
        case .failure(let error):
          break
        }
        
//        guard let data = response.data else {
//          print("QuickApi has decoding failure.")
//          if let error = response.error { completion(.failure(error)) }
//          return
//        }
//
//        guard let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
//          print("QuickApi has decoding failure.")
//          if let error = response.error { completion(.failure(error)) }
//          return
//        }
//
//        if let statusCode = response.response?.statusCode {
//          switch statusCode {
//          case 300...599:
//            completion(.failure(response.error!))
//          case 200...299:
//            completion(.success(responseModel))
//          default:
//            break
//          }
//        }
      }
  }
}

// MARK: - Actions For Requests

extension NetworkLayer {
  
  func callRequest<T: Decodable>(url: String,
                                 parameters: Parameters? = nil,
                                 decodeObject: T.Type,
                                 method: HTTPMethod,
                                 completion: @escaping GenericCompletion<T>) {
    let fullUrl = baseApiUrl ?? "" + url
    request(fullUrl: fullUrl, method: method, parameters: parameters, decodeObject: decodeObject) { result in
      switch result {
      case .success(let data):
        completion(.success(data))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

// MARK: - Logic

extension NetworkLayer {
  
  func setBaseUrl(_ url: String) {
    baseApiUrl = url
  }
  
  private func getCustomHttpHeader() {
    if let header = UserDefaults.standard.value(forKey: Constants.customHttpHeader) as? HTTPHeaders {
      customHttpHeader = header
    }
  }
  
  func setCustomHttpHeader(_ header: HTTPHeaders) {
    customHttpHeader = header
    UserDefaults.standard.setValue(header, forKey: Constants.customHttpHeader)
  }
  
  func clearCustomHttpHeader() {
    customHttpHeader = nil
    UserDefaults.standard.setValue(nil, forKey: Constants.customHttpHeader)
  }
  
  func cancelAllRequests() {
    AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
      sessionDataTask.forEach { $0.cancel() }
      uploadData.forEach { $0.cancel() }
      downloadData.forEach { $0.cancel() }
    }
  }
  
  private func getHeader() -> HTTPHeaders {
    if let customHttpHeader = customHttpHeader {
      return customHttpHeader
    }
    
    let userDefaults = UserDefaults.standard
    if let token: String = userDefaults.value(forKey: Constants.token) as? String {
      return  ["Authorization": "Bearer \(token)",
               "Content-Type" : "application/json",
               "Accept-Language": languageCode ?? ""]
    }
    return  ["Content-Type" : "application/json",
             "Accept-Language": languageCode ?? ""]
  }
  
  private func getEncodingType(method: HTTPMethod) -> ParameterEncoding {
    return method == .get ? URLEncoding.queryString : JSONEncoding.default
  }
  
  private func showJsonResponse(_ data:Data?) {
    if !(showResponseInConsole ) { return }
    guard let data = data else { return }
    
    if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
      print("************************* Quick Api Response ***************************** \n \(jsonDictionary)")
    } else if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]] {
      print("************************* Quick Api Response ***************************** \n \(jsonDictionary)")
    }
  }
  
  private func getCustomError() {
    //    Burayı en son custom
  }
}
#endif
