//
//  Quick.swift
//  
//
//  Created by Ferhan Akkan on 27.09.2021.
//

#if os(iOS)

import Foundation
import Alamofire

public typealias GenericResponseCompletion<T: Decodable> = (Result<T,QuickError<T>>) -> ()

public final class Quick {
  
  public static var shared = Quick()
  
  private let layerHelper = LayerHelper()
  private lazy var networkLayer = NetworkLayer(layerHelper: layerHelper)
  private lazy var multipartNetworkLayer = MultipartNetworkLayer(layerHelper: layerHelper)
}

// MARK: - Logic

extension Quick {
  
  public func cancelAllRequests() {
    layerHelper.cancelAllRequests()
  }
  
  public func showResponseInDebug(_ isEnable: Bool) {
    layerHelper.showResponseInDebug(isEnable)
  }
  
  public func setTimeOut(_ time: Int) {
    networkLayer.sessionManager = layerHelper.setTimeOut(time)
    multipartNetworkLayer.sessionManager = layerHelper.setTimeOut(time)
  }
  
  public func setMaxNumberOfRetry(_ count: Int) {
    layerHelper.setMaxNumberOfRetry(count)
  }
  
  public func setApiBaseUrlWith(apiType: ApiTypes, apiUrl: String) {
    networkLayer.setApiBaseUrlWith(apiType: apiType, apiUrl: apiUrl)
  }
  
  public func setApiBaseUrlForMultipartWith(apiType: ApiTypes, apiUrl: String) {
    networkLayer.setApiBaseUrlWith(apiType: apiType, apiUrl: apiUrl)
  }
  
  public func setCustomErrorManager(completion: @escaping CustomErrorCompletion) {
    networkLayer.customErrorManager.setCustomError = completion
  }
  
  public func setCustomErrorManagerForMultipart(completion: @escaping CustomErrorCompletion) {
    networkLayer.customErrorManager.setCustomError = completion
  }
  
  public func setHeaderCompletion(completion: @escaping HttpHeaderCompletion) {
    networkLayer.headerCompletion = completion
  }
  
  public func setHeaderCompletionForMultipart(completion: @escaping HttpHeaderCompletion) {
    networkLayer.headerCompletion = completion
  }
  
  public func setUnauthorized(completion: @escaping UnauthorizedCompletion) {
    networkLayer.unauthorizedCompletion = completion
  }
  
  public func retryAfterUnauthStatus() {
    networkLayer.retryCompletion?()
  }
  
  public func setUnauthorizedForMultipart(completion: @escaping UnauthorizedCompletion) {
    multipartNetworkLayer.unauthorizedCompletion = completion
  }
  
  public func retryAfterUnauthStatusForMultipart() {
    multipartNetworkLayer.retryCompletion?()
  }
}


// MARK: - Network Requests

extension Quick {
  
  public func get<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .get, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
  
  public func post<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type,  apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .post, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
  
  public func put<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .put, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
  
  public func patch<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .patch, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
  
  public func delete<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .delete, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
}

// MARK: - Custom Requests

extension Quick {
  
  public func customRequest<T: Decodable>(full: String,
                                          header: HTTPHeaders,
                                          method: HTTPMethod,
                                          parameters: Parameters?,
                                          decodeObject: T.Type,
                                          completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: full,
                         method: method,
                         header: header,
                         parameters: parameters,
                         decodeObject: decodeObject,
                         retryCount: 1,
                         apiType: .custom,
                         completion: completion)
  }
}

// MARK: - Request Multipart

extension Quick {
  
  public func upload<T: Decodable>(url: String,
                                   method: HTTPMethod,
                                   parameters: [String: Any],
                                   datas: [MultipartDataModel],
                                   decodeObject: T.Type,
                                   apiType: ApiTypes,
                                   completion: @escaping GenericResponseCompletion<T>) {
    multipartNetworkLayer.upload(url: url,
                                 header: nil,
                                 method: method,
                                 parameters: parameters,
                                 datas: datas,
                                 decodeObject: decodeObject,
                                 apiType: apiType,
                                 completion: completion)
  }
  
  public func customMultipartUploadRequest<T: Decodable>(fullUrl: String,
                                                         header: HTTPHeaders,
                                                         method: HTTPMethod,
                                                         parameters: [String: Any],
                                                         datas: [MultipartDataModel],
                                                         decodeObject: T.Type,
                                                         completion: @escaping GenericResponseCompletion<T>) {
    multipartNetworkLayer.upload(url: fullUrl,
                                 header: header,
                                 method: method,
                                 parameters: parameters,
                                 datas: datas,
                                 decodeObject: decodeObject,
                                 apiType: .custom,
                                 completion: completion)
  }
}

#endif
