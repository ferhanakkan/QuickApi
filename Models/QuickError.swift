//
//  QuickError.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 29.09.2021.
//

import Alamofire

public struct QuickError<T: Decodable>: Error {
  
  public let alamofireError: AFError
  public let response: T?
  public let customErrorMessage: Any?
  public let json: [String : Any]?
  public let data: Data?
  public let statusCode: Int?
}
