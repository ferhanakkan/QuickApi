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
  
  var sessionManager: Session?
  
  private let layerHelper: LayerHelper
  
  weak var headerDelegate: HttpCustomizationProtocols?
  weak var unauthorizedDelegate: UnauthorizedCustomizationProtocol?
  weak var customErrorDelegate: ErrorCustomizationProtocol?
  
  var unauthorizedServiceActive: Bool = false
  
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
                             isUnauthRequest: Bool = false,
                             completion: @escaping GenericResponseCompletion<T>) {
    let encodingType = layerHelper.getEncodingType(method: method)
    
    guard let sessionManager = sessionManager else {
      print("Session Manager Issue detected.")
      return
    }
    
    let fullUrl = getFullUrl(url: url, apiType: apiType)
    let httpHeader = header == nil ? (headerDelegate?.httpHeaderCustomization(apiType: apiType) ?? [:]) : header
    
    sessionManager
      .request(fullUrl, method: method, parameters: parameters, encoding: encodingType, headers: httpHeader)
      .validate(statusCode: 200..<300)
      .responseDecodable(of: T.self) { [weak self] response in
        print("\n\n\n ***************** Request send to = \(response.request?.url?.absoluteString ?? " *****************")")
        self?.layerHelper.showJsonResponse(response.data)
        
        switch response.result {
        case .success( _):
          guard let value = response.value else {
            return
          }
          completion(.success(value))
          
        case .failure(let error):
          guard let self = self else { return }
          if self.layerHelper.maxRetryCount <= retryCount {
            print("\n\n\n ***************** Internet connection error. Failed with many retry attempts. ***********************")
            
            guard let data = response.data,
                  let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
              print("\n\n\n ***************** QuickApi has decoding failure. ***************** ")
              let quickError = QuickError<T>(alamofireError: error,
                                             response: nil,
                                             customErrorMessage: self.customErrorDelegate?.errorCustomization(json: self.layerHelper.getJsonFromData(response.data),
                                                                                                              apiType: apiType),
                                             json: self.layerHelper.getJsonFromData(response.data),
                                             data: response.data,
                                             statusCode: response.response?.statusCode ?? 0)
              completion(.failure(quickError))
              return
            }
            
            let quickError = QuickError<T>(alamofireError: error,
                                           response: responseModel,
                                           customErrorMessage: self.customErrorDelegate?.errorCustomization(json: self.layerHelper.getJsonFromData(response.data),
                                                                                                            apiType: apiType),
                                           json: self.layerHelper.getJsonFromData(data),
                                           data: data,
                                           statusCode: response.response?.statusCode ?? 0)
            
            switch response.response?.statusCode ?? 0 {
            case 401 where isUnauthRequest && self.unauthorizedServiceActive:
              self.unauthorizedDelegate?.unauthorizedCustomization(apiType: apiType, completion: { [weak self] retryLastResponse in
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                  self?.request(url: url,
                               method: method,
                               header: httpHeader,
                               parameters: parameters,
                               decodeObject: decodeObject,
                               retryCount: retryCount + 1,
                               apiType: apiType,
                               completion: completion)
                }
              })
              
            default:
              completion(.failure(quickError))
            }
            
          } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
              print("n\n\n ************* Going to retry with #: \(retryCount+1) ***********************")
              self.request(url: url,
                           method: method,
                           header: httpHeader,
                           parameters: parameters,
                           decodeObject: decodeObject,
                           retryCount: retryCount + 1,
                           apiType: apiType,
                           isUnauthRequest: retryCount + 1 == self.layerHelper.maxRetryCount,
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
      return "\(String(describing: primaryApi ?? ""))\(url)"
    case .secondary:
      return "\(String(describing: secondaryApi ?? ""))\(url)"
    case .tertiary:
      return "\(String(describing: tertiaryApi ?? ""))\(url)"
    case .custom:
      return url
    }
  }
}

#endif
