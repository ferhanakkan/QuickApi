//
//  Constants.swift
//  
//
//  Created by Ferhan Akkan on 2.10.2021.
//

import Foundation

struct Constants {
  static let sessionIssue = "Session Manager Issue detected."
  static let manyAttempts = "\n\n ********* QuickApi Request Failed with many retry attempts. *********"
  static let failureDecoding = "\n\n ********* QuickApi has decoding failure. Usually the cause of the error is due to the wrong variable type in the object. ********* \n\n"
  static let retryRequest = "\n\n ********* QuickApi Going to retry last request with #: $ ********* \n\n"
  static let requestUrl = "\n\n ********* QuickApi Request send to = $ ********* \n\n"
}
