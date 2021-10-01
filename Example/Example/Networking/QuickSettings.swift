//
//  QuickSettings.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import QuickApi
import Alamofire

final class QuickSettings: HttpCustomizationProtocols, UnauthorizedCustomizationProtocol, ErrorCustomizationProtocol {
  
  private var tmdbToken: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MGE4ZTIxNzY4NTZhMDUwMjRhZDkzYzQwMWU3MDk5MiIsInN1YiI6IjYwNDU0ZmNjZDhlMjI1MDA0NTUyZjg5OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0eT2aN1gqiaZADmuf158U4fTJfS1jbQtD96g_kEbNhk"
  
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
    Quick.shared.setApiBaseUrlWith(apiType: .secondary, apiUrl: "https://api.themoviedb.org/4/")
//    Quick.shared.setApiBaseUrlForMultipartWith(apiType: .primary, apiUrl: "")
  }
  
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders? {
    switch apiType {
    case .primary:
//        OpenWeatherMap api doesn't require token on http header cause of that you don't have to set header.
      return nil
      
    case .secondary:
      return [
        "Authorization" : "Bearer \(tmdbToken)",
        "Content-Type" : "application/json;charset=utf-8"
      ]
      
    case .tertiary:
      return nil
      
    case .custom:
      return nil
    }
  }
  
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping (Bool) -> ()) {
    switch apiType {
    case .primary:
      //We can't handle unauthorized status in OpenWeatherMap because it gets token in query. You have to change request parameters.
      break
      
    case .secondary:
      tmdbToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MGE4ZTIxNzY4NTZhMDUwMjRhZDkzYzQwMWU3MDk5MiIsInN1YiI6IjYwNDU0ZmNjZDhlMjI1MDA0NTUyZjg5OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0eT2aN1gqiaZADmuf158U4fTJfS1jbQtD96g_kEbNhk"
      completion(true)
      
    case .tertiary:
      break
      
    case .custom:
      break
    }
  }
  
  func errorCustomization(json: [[String : Any]]?, apiType: ApiTypes) -> Any? {
    switch apiType {
    case .primary:
      return json?[0]["message"]
      
    case .secondary:
      return nil
      
    case .tertiary:
      return nil
      
    case .custom:
      return nil
    }
  }
}
