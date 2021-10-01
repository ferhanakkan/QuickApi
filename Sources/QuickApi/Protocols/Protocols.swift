//
//  CustomizationProtocols.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import Foundation
import Alamofire

public protocol HttpCustomizationProtocols: AnyObject {
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders?
}

public protocol UnauthorizedCustomizationProtocol: AnyObject {
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping (_ retryLastRequest: Bool) -> ())
}

public protocol ErrorCustomizationProtocol: AnyObject {
  func errorCustomization(json: [String : Any]?, apiType: ApiTypes) -> Any?
}

public extension HttpCustomizationProtocols {
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders? {
    nil
  }
}

public extension UnauthorizedCustomizationProtocol {
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping (_ retryLastRequest: Bool) -> ()) {
  }
}

public extension ErrorCustomizationProtocol {
  func errorCustomization(json: [String : Any]?, apiType: ApiTypes) -> Any? {
    nil
  }
}
