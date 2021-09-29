//
//  NetworkLayer.swift
//  
//
//  Created by Ferhan Akkan on 27.09.2021.
//


#if os(iOS)

import Alamofire
import Foundation

public typealias HttpHeaderCompletion = ((ApiTypes)->(HTTPHeaders))

final class NetworkLayer {
  
  var customErrorManager: CustomErrorManager = CustomErrorManager()
  
  private let configuration = URLSessionConfiguration.default
  private var sessionManager: Session?
  
  private var customHttpHeader: HTTPHeaders?
  private var showResponseInConsole: Bool = false
  
  var headerCompletion: HttpHeaderCompletion?
  var authCompletion: (() -> ())?
  var retryCompletion: (() -> ())?
  
  var authTriggered: Bool = false
  
  private var requestTimeOut = 0 {
    didSet {
      if requestTimeOut < 1 { requestTimeOut = 1 }
      configuration.timeoutIntervalForRequest = Double(requestTimeOut)
      configuration.timeoutIntervalForResource = Double(requestTimeOut)
      sessionManager = Alamofire.Session(configuration: configuration)
    }
  }
  
  private var primaryApi: String?
  private var secondaryApi: String?
  private var tertiaryApi: String?
  
  private var maxRetryCount: Int = 3
  
  init() {
    configuration.timeoutIntervalForRequest = Double(1)
    configuration.timeoutIntervalForResource = Double(1)
    sessionManager = Alamofire.Session(configuration: configuration)
  }
}

// MARK: - Network For Requests

extension NetworkLayer {
  
  func request<T: Decodable>(url: String,
                             method: HTTPMethod,
                             header: HTTPHeaders? = nil,
                             parameters: Parameters?,
                             decodeObject: T.Type,
                             retryCount: Int = 1,
                             apiType: ApiTypes = .Primary,
                             completion: @escaping GenericCompletion<T>) {
    
    let encodingType = getEncodingType(method: method)
    
    guard let sessionManager = sessionManager else {
      print("Session Manager Issue detected.")
      return
    }
    
    let fullUrl = getFullUrl(url: url, apiType: apiType)
    let httpHeader = header == nil ? (headerCompletion?(apiType) ?? [:]) : header
    
    sessionManager
      .request(fullUrl, method: method, parameters: parameters, encoding: encodingType, headers: httpHeader)
      .validate(statusCode: 200..<300)
      .responseDecodable(of: T.self) { [weak self] response in
        
        self?.showJsonResponse(response.data)
        
        switch response.result {
        case .success( _):
          
          guard let value = response.value else {
            print("QuickApi has decoding failure.")
            return
          }
          self?.authTriggered = false
          completion(.success(value))
          
        case .failure(let error):
          guard let self = self else { return }
          if self.maxRetryCount == retryCount {
            print("***************** Internet connection error. Failed with many retry attempts. ***********************")
            
            guard let data = response.data,
                  let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
              print("QuickApi has decoding failure.")
              let quickError = QuickError<T>(alamofireError: error,
                                             response: nil,
                                             customErrorMessage: self.customErrorManager.getCustomError(json: self.getJsonFromData(response.data), apiType: apiType) as Any,
                                             json: self.getJsonFromData(response.data),
                                             data: response.data,
                                             statusCode: response.response?.statusCode ?? 0)
              completion(.failure(quickError))
              return
            }
            
            let quickError = QuickError<T>(alamofireError: error,
                                           response: responseModel,
                                           customErrorMessage: self.customErrorManager.getCustomError(json: self.getJsonFromData(response.data), apiType: apiType) as Any,
                                           json: self.getJsonFromData(data),
                                           data: data,
                                           statusCode: response.response?.statusCode ?? 0)
            
            if let statusCode = response.response?.statusCode,
               statusCode == 401 && !self.authTriggered {
              self.authTriggered = true
              
              self.retryCompletion = {
                self.authTriggered = false
                self.request(url: fullUrl,
                             method: method,
                             header: httpHeader,
                             parameters: parameters,
                             decodeObject: decodeObject,
                             retryCount: retryCount + 1,
                             completion: completion)
              }
              
            } else {
              completion(.failure(quickError))
            }
            
          } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
              print("***************** Going to retry with #: \(retryCount+1) ***********************")
              self.request(url: fullUrl,
                           method: method,
                           header: httpHeader,
                           parameters: parameters,
                           decodeObject: decodeObject,
                           retryCount: retryCount + 1,
                           completion: completion)
            }
          }
        }
      }
  }
}

// MARK: - Logic

extension NetworkLayer {
  
  func setMaxNumberOfRetry(_ count: Int) {
    maxRetryCount = count
  }
  
  func setApiBaseUrlWith(apiType: ApiTypes, apiUrl: String) {
    switch apiType {
    case .Primary:
      primaryApi = apiUrl
    case .Secondary:
      secondaryApi = apiUrl
    case .Tertiary:
      secondaryApi = apiUrl
    case .Custom:
      break
    }
  }
  
  func cancelAllRequests() {
    AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
      sessionDataTask.forEach { $0.cancel() }
      uploadData.forEach { $0.cancel() }
      downloadData.forEach { $0.cancel() }
    }
  }
  
  private func getFullUrl(url: String, apiType: ApiTypes) -> String {
    switch apiType {
    case .Primary:
      return primaryApi ?? "" + url
    case .Secondary:
      return secondaryApi ?? "" + url
    case .Tertiary:
      return tertiaryApi ?? "" + url
    case .Custom:
      return url
    }
  }
  
  private func getEncodingType(method: HTTPMethod) -> ParameterEncoding {
    return method == .get ? URLEncoding.queryString : JSONEncoding.default
  }
  
  public func showResponseInDebug(_ isEnable: Bool) {
    showResponseInConsole = isEnable
  }
  
  private func showJsonResponse(_ data: Data?) {
    if !(showResponseInConsole ) { return }
    guard let data = data else { return }
    
    if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
      print("************************* Quick Api Response ***************************** \n \(jsonDictionary)")
    } else if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]] {
      print("************************* Quick Api Response ***************************** \n \(jsonDictionary)")
    }
  }
  
  private func getJsonFromData(_ data: Data?) -> [String : Any]? {
    guard let data = data else { return nil }
    if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
      return jsonDictionary
    }
    return nil
  }
}

#endif
