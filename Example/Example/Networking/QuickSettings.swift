//
//  QuickSettings.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import QuickApi
import Alamofire

final class QuickSettings: HttpCustomizationProtocols, UnauthorizedCustomizationProtocol, ErrorCustomizationProtocol {
  
  init() {
    setQuickApiSettings()
  }
  
  private func setQuickApiSettings() {
    Quick.shared.setMaxNumberOfRetry(3)
    Quick.shared.setTimeOut(10)
    Quick.shared.showResponseInDebug(true)
    
    Quick.shared.setUnauthorized(delegate: self)
    Quick.shared.setHeaderCompletion(delegate: self)
    Quick.shared.setCustomErrorManager(delegate: self)
    
    Quick.shared.setUnauthorizedServiceActive(true)
    
    Quick.shared.setApiBaseUrlWith(apiType: .primary, apiUrl: "http://api.openweathermap.org/")
//    Quick.shared.setApiBaseUrlWith(apiType: .secondary, apiUrl: "")
//    Quick.shared.setApiBaseUrlForMultipartWith(apiType: .primary, apiUrl: "")
  }
  
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders? {
    switch apiType {
    case .primary:
//        OpenWeatherMap api doesn't require token on http header cause of that you don't have to set header.
      return nil
    case .secondary:
      return nil
    case .tertiary:
      return nil
    case .custom:
      return nil
    }
  }
  
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping (Bool) -> ()) {
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
  
  func errorCustomization(json: [String : Any]?, apiType: ApiTypes) -> Any? {
    switch apiType {
    case .primary:
      return json?["message"]
    case .secondary:
      return nil
    case .tertiary:
      return nil
    case .custom:
      return nil
    }
  }
}
