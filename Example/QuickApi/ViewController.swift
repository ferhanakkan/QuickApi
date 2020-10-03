//
//  ViewController.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 10/03/2020.
//  Copyright (c) 2020 Ferhan Akkan. All rights reserved.
//

import UIKit
import QuickApi

public struct Test: Codable {
    var a: Int?
}

struct FarmerFieldEditApsModel: Codable {
    var aps: [SubFarmerFieldEditApsModel]? = []
}

struct SubFarmerFieldEditApsModel: Codable {
    var id: Int?
    var name: String?
}

struct CoreResponse <T: Codable>: Decodable{
    let status: Int?
    let message: CoreMessage?
    let errors: String?
    let data: T?
}

struct CoreMessage: Codable {
    var text: String?
    var type: String?
}



class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        Quick.shared.setApiBaseUrl(url: "http://51.124.79.0/")
        Quick.shared.timeOutTime = 20
        Quick.shared.showResponseJSONOnConsole = true
        Quick.shared.getRequest(endPoint: "api/", parameters: ["do":"produce/aps"], responseObject: CoreResponse<FarmerFieldEditApsModel>.self) { (res, err) in
            if let controledError = err {
                print(controledError.localizedDescription)
            } else {

            }
        }
        
        
        
        
        LoadingView.show()
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

