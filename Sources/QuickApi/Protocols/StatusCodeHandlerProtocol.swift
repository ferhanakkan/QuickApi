//
//  StatusCodeHandlerProtocol.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import Foundation
import Alamofire

public protocol StatusCodeHandlerProtocol: AnyObject {
  func handleStatusCodeFor(apiType: ApiTypes, statusCode: Int)
}

public extension StatusCodeHandlerProtocol {
  func handleStatusCodeFor(apiType: ApiTypes, statusCode: Int) {
  }
}
