//
//  Quick.swift
//  
//
//  Created by Ferhan Akkan on 27.09.2021.
//

#if os(iOS)

import Foundation
import Alamofire

public typealias GenericCompletion<T: Decodable> = (Result<T,AFError>) -> ()

public final class Quick {
  
  public static var shared = Quick()
  
  private let networkLayer = NetworkLayer()
  private let multipartNetworkLayer = MultipartNetworkLayer()
  private let userDefaults = UserDefaults.standard
  
  public init() {
    
  }
}

// MARK: - Request Multipart

extension Quick {
  
  public func uploadMultipart<T: Decodable>(fullUrl: String,
                                            header: HTTPHeaders,
                                            method: HTTPMethod,
                                            parameters: [String: Any],
                                            datas: [MultipartDataModel],
                                            decodeObject: T.Type,
                                            completion: @escaping GenericCompletion<T>) {
    multipartNetworkLayer.callRequest(fullUrl: fullUrl,
                                      header: header,
                                      method: method,
                                      parameters: parameters,
                                      datas: datas,
                                      decodeObject: decodeObject,
                                      completion: completion)
  }
}

// MARK: - Logic Network

extension Quick {
  
  public func clearToken() {
    userDefaults.setValue(nil, forKey: Constants.token)
  }
  
  public func setToken(token: String) {
    userDefaults.setValue(token, forKey: Constants.token)
  }
  
  public func setAcceptlanguage(code: String) {
    userDefaults.setValue(code, forKey: Constants.languageCode)
  }
  
  public func clearAcceptLanguage() {
    userDefaults.setValue(nil, forKey: Constants.languageCode)
  }
  
  public func setBaseUrl(_ url: String) {
    networkLayer.setBaseUrl(url)
  }
  
  public func setCustomHttpHeader(_ header: HTTPHeaders) {
    networkLayer.setCustomHttpHeader(header)
  }
  
  public func clearCustomHttpHeader() {
    networkLayer.clearCustomHttpHeader()
  }
}


// MARK: - Requests Network

extension Quick {
  
  func get<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, retryCount: Int? ,completion: @escaping GenericCompletion<T>) {
    networkLayer.callRequest(url: url, parameters: parameters, decodeObject: decodeObject, method: .get, completion: completion, retryCount: retryCount)
  }
  
  func post<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, retryCount: Int? ,completion: @escaping GenericCompletion<T>) {
    networkLayer.callRequest(url: url, parameters: parameters, decodeObject: decodeObject, method: .post, completion: completion, retryCount: retryCount)
  }
  
  func put<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, retryCount: Int? ,completion: @escaping GenericCompletion<T>) {
    networkLayer.callRequest(url: url, parameters: parameters, decodeObject: decodeObject, method: .put, completion: completion, retryCount: retryCount)
  }
  
  func patch<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, retryCount: Int? ,completion: @escaping GenericCompletion<T>) {
    networkLayer.callRequest(url: url, parameters: parameters, decodeObject: decodeObject, method: .patch, completion: completion, retryCount: retryCount)
  }
  
  func delete<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, retryCount: Int? ,completion: @escaping GenericCompletion<T>) {
    networkLayer.callRequest(url: url, parameters: parameters, decodeObject: decodeObject, method: .delete, completion: completion, retryCount: retryCount)
  }
}

#endif
