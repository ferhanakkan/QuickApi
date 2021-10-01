//
//  QuickSettingsMultipart.swift
//  Example
//
//  Created by Ferhan Akkan on 2.10.2021.
//

import QuickApi
import Alamofire

final class QuickSettingsMultipart {
  
  static let shared = QuickSettings()
  
  init() {
    setQuickApiSettings()
  }
  
  private func setQuickApiSettings() {
    Quick.shared.setMaxNumberOfRetry(3)
    Quick.shared.setTimeOut(10)
    Quick.shared.showResponseInDebug(true)
    
//    Quick.shared.setUnauthorized(delegate: self)
//    Quick.shared.setHeaderCompletion(delegate: self)
//    Quick.shared.setCustomErrorManager(delegate: self)
//    Quick.shared.setStatusCodeHandler(delegate: self)
//
//    Quick.shared.setApiBaseUrlWith(apiType: .primary, apiUrl: "http://api.openweathermap.org/")
//    Quick.shared.setApiBaseUrlWith(apiType: .secondary, apiUrl: "https://api.themoviedb.org/4/")
  }
}

// MARK: - Unauthorized Handling

extension QuickSettingsMultipart: UnauthorizedCustomizationProtocol {
  
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping (Bool) -> ()) {
    switch apiType {
    case .primary:
      //We can't handle unauthorized status in OpenWeatherMap because it gets token in query. You have to change request parameters.
      break
      
    case .secondary:
//      setTrueTokenForSecondartApi()
      completion(true)
      
    case .tertiary:
      break
      
    case .custom:
      break
    }
  }
}

// MARK: - Status Code Handling

extension QuickSettingsMultipart: StatusCodeHandlerProtocol {
  
  func handleStatusCodeFor(apiType: ApiTypes, statusCode: Int) {
    switch apiType {
    case .primary:
      break
      
    case .secondary:
      break
      
    case .tertiary:
      break
      
    case .custom:
      break
    }
  }
}

// MARK: - Custom Error Handling

extension QuickSettingsMultipart: ErrorCustomizationProtocol {
  
  func errorCustomization(json: [String : Any]?, apiType: ApiTypes) -> Any? {
    switch apiType {
    case .primary:
      return json?["message"]
      
    case .secondary:
      return json?["status_code"]
      
    case .tertiary:
      return nil
      
    case .custom:
      return json?["status_code"]
    }
  }
}

// MARK: - Http Header Handling

extension QuickSettingsMultipart: HttpCustomizationProtocols {
  
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders? {
    switch apiType {
    case .primary:
//        OpenWeatherMap api doesn't require token on http header cause of that you don't have to set header.
      return nil
      
    case .secondary:
      return [
        "Authorization" : "Bearer test",
        "Content-Type" : "application/json;charset=utf-8"
      ]
      
    case .tertiary:
      return nil
      
    case .custom:
      return nil
    }
  }
}
