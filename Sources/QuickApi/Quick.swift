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
  
  /// Cancel all requests.
  public func cancelAllRequests() {
    layerHelper.cancelAllRequests()
  }
  
  /// It allows the incoming response to be seen on the debug.
  public func showResponseInDebug(_ isEnable: Bool) {
    layerHelper.showResponseInDebug(isEnable)
  }
  
  /// Sets the timeout for the discarded request.
  public func setTimeOut(_ time: Int) {
    networkLayer.sessionManager = layerHelper.setTimeOut(time)
    multipartNetworkLayer.sessionManager = layerHelper.setTimeOut(time)
  }
  
  /// It determines how many times it will be repeated if the request is unsuccessful.
  public func setMaxNumberOfRetry(_ count: Int) {
    layerHelper.setMaxNumberOfRetry(count)
  }
  
  /// Sets api url.
  public func setApiBaseUrlWith(apiType: ApiTypes, apiUrl: String) {
    networkLayer.setApiBaseUrlWith(apiType: apiType, apiUrl: apiUrl)
  }
  
  /// Set error delegate for network requests.
  public func setCustomErrorManager(delegate: ErrorCustomizationProtocol) {
    networkLayer.customErrorDelegate = delegate
  }
  
  /// Set header delegate for network requests.
  public func setHeaderCompletion(delegate: HttpCustomizationProtocols) {
    networkLayer.headerDelegate = delegate
  }
  
  /// Set unauthorized delegate for network requests.
  public func setUnauthorized(delegate: UnauthorizedCustomizationProtocol) {
    networkLayer.unauthorizedDelegate = delegate
  }
  
  /// Set status delegate for network requests.
  public func setStatusCodeHandler(delegate: StatusCodeHandlerProtocol) {
    networkLayer.statusCodeDelegate = delegate
  }
}

// MARK: - Network Delegate

extension Quick {
  
  /// Sets api url for multipart.
  public func setApiBaseUrlWithForMultipart(apiType: ApiTypes, apiUrl: String) {
    multipartNetworkLayer.setApiBaseUrlWith(apiType: apiType, apiUrl: apiUrl)
  }
  
  /// Set error delegate for network requests for multipart.
  public func setCustomErrorManagerForMultipart(delegate: ErrorCustomizationProtocol) {
    multipartNetworkLayer.customErrorDelegate = delegate
  }
  
  /// Set header delegate for network requests for multipart.
  public func setHeaderCompletionForMultipart(delegate: HttpCustomizationProtocols) {
    multipartNetworkLayer.headerDelegate = delegate
  }
  
  /// Set unauthorized delegate for network requests for multipart.
  public func setUnauthorizedForMultipart(delegate: UnauthorizedCustomizationProtocol) {
    multipartNetworkLayer.unauthorizedDelegate = delegate
  }
  
  /// Set status delegate for network requests for multipart.
  public func setStatusCodeHandlerForMultipart(delegate: StatusCodeHandlerProtocol) {
    multipartNetworkLayer.statusCodeDelegate = delegate
  }
}

// MARK: - Network Requests

extension Quick {
  
  /// Get Request
  public func get<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .get, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
  
  /// Post Request
  public func post<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type,  apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .post, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
  
  /// Put Request
  public func put<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .put, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
  
  /// Patch Request
  public func patch<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .patch, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
  
  /// Delete Request
  public func delete<T: Decodable>(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>) {
    networkLayer.request(url: url, method: .delete, parameters: parameters, decodeObject: decodeObject, apiType: apiType, completion: completion)
  }
}

// MARK: - Custom Requests

extension Quick {
  
  /// Custom request you can create request as you wish.
  public func customRequest<T: Decodable>(full: String,
                                          header: HTTPHeaders? = nil,
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
  
  /// Multipart Request
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
  
  /// You can create multipart request as you wish.
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
