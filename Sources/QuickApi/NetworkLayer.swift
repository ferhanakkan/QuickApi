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
public typealias UnauthorizedCompletion = ((ApiTypes)->())

final class NetworkLayer {
  
  var customErrorManager: CustomErrorManager = CustomErrorManager()
  
  var sessionManager: Session?
  
  private let layerHelper: LayerHelper
  
  var headerCompletion: HttpHeaderCompletion?
  var unauthorizedCompletion: UnauthorizedCompletion?
  var retryCompletion: (() -> ())?
  
  var authTriggered: Bool = false
  
  private var primaryApi: String?
  private var secondaryApi: String?
  private var tertiaryApi: String?
  
  
  init(layerHelper: LayerHelper) {
    self.layerHelper = layerHelper
    sessionManager = layerHelper.setTimeOut(10)
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
                             apiType: ApiTypes = .primary,
                             completion: @escaping GenericResponseCompletion<T>) {
    
    let encodingType = layerHelper.getEncodingType(method: method)
    
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
        
        self?.layerHelper.showJsonResponse(response.data)
        
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
          if self.layerHelper.maxRetryCount == retryCount {
            print("***************** Internet connection error. Failed with many retry attempts. ***********************")
            
            guard let data = response.data,
                  let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
              print("QuickApi has decoding failure.")
              let quickError = QuickError<T>(alamofireError: error,
                                             response: nil,
                                             customErrorMessage: self.customErrorManager.getCustomError(json: self.layerHelper.getJsonFromData(response.data), apiType: apiType) as Any,
                                             json: self.layerHelper.getJsonFromData(response.data),
                                             data: response.data,
                                             statusCode: response.response?.statusCode ?? 0)
              completion(.failure(quickError))
              return
            }
            
            let quickError = QuickError<T>(alamofireError: error,
                                           response: responseModel,
                                           customErrorMessage: self.customErrorManager.getCustomError(json: self.layerHelper.getJsonFromData(response.data), apiType: apiType) as Any,
                                           json: self.layerHelper.getJsonFromData(data),
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
  
  func setApiBaseUrlWith(apiType: ApiTypes, apiUrl: String) {
    switch apiType {
    case .primary:
      primaryApi = apiUrl
    case .secondary:
      secondaryApi = apiUrl
    case .tertiary:
      secondaryApi = apiUrl
    case .custom:
      break
    }
  }
  
  private func getFullUrl(url: String, apiType: ApiTypes) -> String {
    switch apiType {
    case .primary:
      return primaryApi ?? "" + url
    case .secondary:
      return secondaryApi ?? "" + url
    case .tertiary:
      return tertiaryApi ?? "" + url
    case .custom:
      return url
    }
  }
}

#endif
