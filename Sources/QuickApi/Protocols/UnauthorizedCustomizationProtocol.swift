//
//  UnauthorizedCustomizationProtocol.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import Foundation
import Alamofire

public protocol UnauthorizedCustomizationProtocol: AnyObject {
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping () -> ())
}

public extension UnauthorizedCustomizationProtocol {
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping () -> ()) {
  }
}
