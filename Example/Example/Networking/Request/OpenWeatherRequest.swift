//
//  OpenWeatherRequest.swift
//  Example
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import Foundation

struct OpenWeatherRequest: Codable {
  var appid: String
  var q: String
}
