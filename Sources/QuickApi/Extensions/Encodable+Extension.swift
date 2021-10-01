//
//  File.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import Foundation

public extension Encodable {
  func asDictionary() -> [String: Any] {
    
    guard let data = try? JSONEncoder().encode(self),
          let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      return [:]
    }
    return dictionary
  }
}
