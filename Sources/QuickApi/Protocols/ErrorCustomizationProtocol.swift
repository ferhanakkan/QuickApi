//
//  ErrorCustomizationProtocol.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import Foundation
import Alamofire

public protocol ErrorCustomizationProtocol: AnyObject {
  func errorCustomization(json: [String : Any]?, apiType: ApiTypes) -> Any?
}

public extension ErrorCustomizationProtocol {
  func errorCustomization(json: [String : Any]?, apiType: ApiTypes) -> Any? {
    nil
  }
}
