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
  weak var statusCodeDelegate: StatusCodeHandlerProtocol?
  
  private var unauthorizedServiceActive: Bool {
    return !(unauthorizedDelegate == nil)
  }
  
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
      fatalError(Constants.sessionIssue)
    }
    
    let fullUrl = getFullUrl(url: url, apiType: apiType)
    let httpHeader = header == nil ? (headerDelegate?.httpHeaderCustomization(apiType: apiType) ?? [:]) : header
    
    sessionManager
      .request(fullUrl, method: method, parameters: parameters, encoding: encodingType, headers: httpHeader)
      .validate(statusCode: 200..<300)
      .responseDecodable(of: T.self) { [weak self] response in
        print(Constants.requestUrl.replacingOccurrences(of: "$", with: response.request?.url?.absoluteString ?? "-"))
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
            print(Constants.manyAttempts)
            self.statusCodeDelegate?.handleStatusCodeFor(apiType: apiType, statusCode: response.response?.statusCode ?? 0)
            guard let data = response.data,
                  let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
              print(Constants.failureDecoding)
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
              self.unauthorizedDelegate?.unauthorizedCustomization(apiType: apiType, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                  self.request(url: url,
                                method: method,
                                header: self.headerDelegate?.httpHeaderCustomization(apiType: apiType) ?? [:],
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
              print(Constants.retryRequest.replacingOccurrences(of: "$", with: String(retryCount + 1)))
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
