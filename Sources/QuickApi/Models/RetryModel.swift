//
//  RetryModel.swift
//  
//
//  Created by Ferhan Akkan on 29.09.2021.
//

import Foundation
import Alamofire

struct RetryModel<T: Decodable> {
  let url: String
  let method: HTTPMethod
  let parameters: Parameters?
  let decodeObject: T.Type
  let apiType: ApiTypes
  let completion: GenericCompletion<T>
}
