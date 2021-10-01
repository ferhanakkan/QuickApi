//
//  LayerHelper.swift
//  
//
//  Created by Ferhan Akkan on 30.09.2021.
//

import Alamofire
import Foundation

final class LayerHelper {
  
  private var showResponseInConsole: Bool = false
  var maxRetryCount: Int = 1
  
  func setMaxNumberOfRetry(_ count: Int) {
    maxRetryCount = count
  }
  
  func setTimeOut(_ time: Int) -> Session {
    let finalTimeOut = time > 1 ? time : 1
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = Double(finalTimeOut)
    configuration.timeoutIntervalForResource = Double(finalTimeOut)
    return Alamofire.Session(configuration: configuration)
  }
  
  func cancelAllRequests() {
    AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
      sessionDataTask.forEach { $0.cancel() }
      uploadData.forEach { $0.cancel() }
      downloadData.forEach { $0.cancel() }
    }
  }
  
  func getEncodingType(method: HTTPMethod) -> ParameterEncoding {
    return method == .get ? URLEncoding.queryString : JSONEncoding.default
  }
  
  func showResponseInDebug(_ isEnable: Bool) {
    showResponseInConsole = isEnable
  }
  
  func showJsonResponse(_ data: Data?) {
    if !(showResponseInConsole ) { return }
    guard let data = data else { return }
    
    if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
      print("************************* Quick Api Response ***************************** \n\n \(jsonDictionary) \n\n")
    } else if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]] {
      print("************************* Quick Api Response ***************************** \n\n \(jsonDictionary) \n\n")
    }
  }
  
  func getJsonFromData(_ data: Data?) -> [String : Any]? {
    guard let data = data else { return nil }
    if let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
      return jsonDictionary
    }
    return nil
  }
}
