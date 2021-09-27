//
//  CustomErrorHandling.swift.swift
//  
//
//  Created by Ferhan Akkan on 28.09.2021.
//

import Foundation

public class ErrorHandling {
  
  public var setCustomError: (([String : Any],Int)->(String?))?
  
  public init() {
    
  }
  
  public func getError(json: [String : Any], statusCode: Int) -> String? {
    return setCustomError?(json, statusCode)
  }
}
