//
//  ViewController.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 10/03/2020.
//  Copyright (c) 2020 Ferhan Akkan. All rights reserved.
//

import UIKit
import QuickApi

struct Testasdf: Decodable {
    var a: Int
}


class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let test = ErrorHandling()
//        Quick.shared.errorModel.closure = { json, statusCode in
//            if let messagea = json["test"] as? [String:Any] {
//                if let text = messagea["test"] as? String {
//                    return text
//                } else {
//                    return nil
//                }
//            }
//            if let message = json["message"] as? [String:Any] {
//                if let text = message["text"] as? String {
//                    return text
//                } else {
//                    return nil
//                }
//            } else if let errors = json["errors"] as? [String: Any] {
//                if let sub = errors["subError"] as? String {
//                    return sub
//                } else {
//                    return nil
//                }
//            } else {
//                return nil
//            }
//        }
//        let ar = Quick.shared.errorModel.getError(json: ["test": ["test": "asdqweasdqwe"]], statusCode: 2)
//        print("test \(ar)")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

