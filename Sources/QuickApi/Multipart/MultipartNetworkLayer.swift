//
//  MultipartNetworkLayer.swift
//  
//
//  Created by Ferhan Akkan on 28.09.2021.
//

#if os(iOS)

import Alamofire
import Foundation

final class MultipartNetworkLayer {
  
  var sessionManager: Session?
  
  let layerHelper: LayerHelper
  
  weak var headerDelegate: HttpCustomizationProtocols?
  weak var unauthorizedDelegate: UnauthorizedCustomizationProtocol?
  weak var customErrorDelegate: ErrorCustomizationProtocol?
  
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

extension MultipartNetworkLayer {
  
  func upload<T: Decodable>(url: String,
                            header: HTTPHeaders? = nil,
                            method: HTTPMethod,
                            parameters: [String: Any],
                            datas: [MultipartDataModel],
                            decodeObject: T.Type,
                            retryCount: Int = 1,
                            apiType: ApiTypes = .primary,
                            completion: @escaping GenericResponseCompletion<T>) {
    
    guard let sessionManager = sessionManager else {
      print("Session Manager Issue detected.")
      return
    }
    
    let fullUrl = getFullUrl(url: url, apiType: apiType)
    let httpHeader = header == nil ? (headerDelegate?.httpHeaderCustomization(apiType: apiType) ?? [:]) : header
    
    sessionManager.upload(multipartFormData: { (multipart) in
      for (key, value) in parameters {
        multipart.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
      }
      
      for selectedData in datas {
        multipart.append(selectedData.data, withName: selectedData.withName,
                         fileName: selectedData.fileName,
                         mimeType: selectedData.mimeType)
      }
      
    },to: url , usingThreshold: UInt64.init(),
    method: method,
    headers: httpHeader)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: T.self) { [weak self] response in
      print("Request send to = \(response.request?.url?.absoluteString ?? "")")
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
          
          if let statusCode = response.response?.statusCode,
             statusCode == 401 && !self.authTriggered {
            self.authTriggered = true
            
//            self.retryCompletion = {
//              self.authTriggered = false
//              self.upload(url: url,
//                          header: httpHeader,
//                          method: method,
//                          parameters: parameters,
//                          datas: datas,
//                          decodeObject: decodeObject,
//                          retryCount: retryCount + 1,
//                          completion: completion)
//            }
          } else {
            completion(.failure(quickError))
          }
          
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            print("***************** Going to retry with #: \(retryCount+1) ***********************")
            self.upload(url: url,
                        header: httpHeader,
                        method: method,
                        parameters: parameters,
                        datas: datas,
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

extension MultipartNetworkLayer {
  
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
    }  }
}
#endif
