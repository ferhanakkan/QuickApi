//
//  MultipartDataModel.swift
//  
//
//  Created by Ferhan Akkan on 28.09.2021.
//

import Foundation

public struct MultipartDataModel {
  var data: Data // Example: file as data
  var withName: String // Example: upload[0]
  var fileName: String // Example: photo.jpg
  var mimeType: String // Example: image/jpeg
}
