//
//  ErrorHandling.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 3.10.2020.
//

import Foundation

public class ErrorHandling {
    
    public var setCustomError: (([String : Any],Int)->(String?))?
    
    public init() {
        
    }
    
    public func getError(json: [String : Any], statusCode: Int) -> String? {
        return setCustomError?(json, statusCode)
    }
}

