//
//  HttpCustomizationProtocols.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import Foundation
import Alamofire

public protocol HttpCustomizationProtocols: AnyObject {
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders?
}

public extension HttpCustomizationProtocols {
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders? {
    nil
  }
}
