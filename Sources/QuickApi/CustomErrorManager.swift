//
//  CustomErrorManager.swift.swift
//  
//
//  Created by Ferhan Akkan on 28.09.2021.
//

import Foundation

public typealias CustomErrorCompletion = (([String : Any]?, ApiTypes)->(Any?))

public class CustomErrorManager {
  
  public var setCustomError: CustomErrorCompletion?
  
  public func getCustomError(json: [String : Any]?,apiType: ApiTypes) -> Any? {
    return setCustomError?(json, apiType)
  }
}

