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
    setQuickApiMultipartSettings()
  }
  
  private func setQuickApiMultipartSettings() {
    
    Quick.shared.setUnauthorizedForMultipart(delegate: self)
    Quick.shared.setHeaderCompletionForMultipart(delegate: self)
    Quick.shared.setCustomErrorManagerForMultipart(delegate: self)
    Quick.shared.setStatusCodeHandlerForMultipart(delegate: self)

    Quick.shared.setApiBaseUrlWith(apiType: .primary, apiUrl: "http://api.openweathermap.org/")
  }
}

// MARK: - Unauthorized Handling

extension QuickSettingsMultipart: UnauthorizedCustomizationProtocol {
  
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping (Bool) -> ()) {
    if apiType == .primary {
      
    } else if  apiType == .custom {
      
    }
  }
}

// MARK: - Status Code Handling

extension QuickSettingsMultipart: StatusCodeHandlerProtocol {
  
  func handleStatusCodeFor(apiType: ApiTypes, statusCode: Int) {
    if apiType == .primary {
      
    } else if  apiType == .custom {
      
    }
  }
}

// MARK: - Custom Error Handling

extension QuickSettingsMultipart: ErrorCustomizationProtocol {
  
  func errorCustomization(json: [String : Any]?, apiType: ApiTypes) -> Any? {
    if apiType == .primary {
      return nil
    } else if  apiType == .custom {
      return nil
    }
    return nil
  }
}

// MARK: - Http Header Handling

extension QuickSettingsMultipart: HttpCustomizationProtocols {
  
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders? {
    if apiType == .primary {
      return nil
    } else if  apiType == .custom {
      return nil
    }
    return nil 
  }
}
