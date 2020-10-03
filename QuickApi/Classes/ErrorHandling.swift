//
//  ErrorHandling.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 3.10.2020.
//

import Foundation

class ErrorHandling {
    
    func getError(json: [String : Any], statusCode: Int) -> String? {
        if let message = json["message"] as? [String:Any] {
            if let text = message["text"] as? String {
                return text
            } else {
                return nil
            }
        } else if let errors = json["errors"] as? [String: Any] {
            if let sub = errors["subError"] as? String {
                return sub
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

