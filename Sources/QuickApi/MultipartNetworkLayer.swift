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
  
  private let configuration = URLSessionConfiguration.default
  private var sessionManager: Session?
  private var showResponseInConsole: Bool = false
  
  #warning("Repeat eklenecek")
  
  /// This parameter sets requests time out.
  private var requestTimeOut = 0 {
    didSet {
      if requestTimeOut < 1 { requestTimeOut = 1 }
      configuration.timeoutIntervalForRequest = Double(requestTimeOut)
      configuration.timeoutIntervalForResource = Double(requestTimeOut)
      sessionManager = Alamofire.Session(configuration: configuration)
    }
  }
}


// MARK: - Network For Requests

extension MultipartNetworkLayer {
  
  private func upload<T: Decodable>(fullUrl: String,
                                    header: HTTPHeaders,
                                    method: HTTPMethod,
                                    parameters: [String: Any],
                                    datas: [MultipartDataModel],
                                    decodeObject: T.Type,
                                    completion: @escaping GenericCompletion<T>) {
    
    guard let sessionManager = sessionManager else {
      print("Session Manager Issue detected.")
      return
    }
    
    sessionManager.upload(multipartFormData: { (multipart) in
      for (key, value) in parameters {
        multipart.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
      }
      
      for selectedData in datas {
        multipart.append(selectedData.data, withName: selectedData.withName,
                         fileName: selectedData.fileName,
                         mimeType: selectedData.mimeType)
      }
      
    },to: fullUrl , usingThreshold: UInt64.init(),
    method: method,
    headers: header)
    .validate(statusCode: 200..<300)
    .responseJSON { [weak self] response in
      
      self?.showJsonResponse(response.data)
      
      guard let data = response.data else {
        print("QuickApi has decoding failure.")
        if let error = response.error { completion(.failure(error)) }
        return
      }
      
      guard let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
        if let error = response.error { completion(.failure(error)) }
        return
      }
      
      if let statusCode = response.response?.statusCode {
        switch statusCode {
        case 300...599:
          completion(.failure(response.error!))
        case 200...299:
          completion(.success(responseModel))
        default:
          break
        }
      }
    }
  }
}

// MARK: - Actions For Requests

extension MultipartNetworkLayer {
  
  func callRequest<T: Decodable>(fullUrl: String,
                                 header: HTTPHeaders,
                                 method: HTTPMethod,
                                 parameters: [String: Any],
                                 datas: [MultipartDataModel],
                                 decodeObject: T.Type,
                                 completion: @escaping GenericCompletion<T>) {
    upload(fullUrl: fullUrl,
           header: header,
           method: method,
           parameters: parameters,
           datas: datas,
           decodeObject: decodeObject) { result in
      switch result {
      case .success(let data):
        completion(.success(data))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

// MARK: - Logic

extension MultipartNetworkLayer {
  
  func cancelAllRequests() {
    AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
      sessionDataTask.forEach { $0.cancel() }
      uploadData.forEach { $0.cancel() }
      downloadData.forEach { $0.cancel() }
    }
  }
  
  private func showJsonResponse(_ data:Data?) {
    if !(showResponseInConsole ) { return }
    guard let data = data else { return }
    
    if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
      print("************************* Quick Api Response ***************************** \n \(jsonDictionary)")
    } else if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]] {
      print("************************* Quick Api Response ***************************** \n \(jsonDictionary)")
    }
  }
  
  private func getCustomError() {
    //    Burayı en son custom
  }
}
#endif
