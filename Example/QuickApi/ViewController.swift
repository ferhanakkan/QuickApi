//
//  ViewController.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 10/03/2020.
//  Copyright (c) 2020 Ferhan Akkan. All rights reserved.
//

import UIKit
import QuickApi

struct TestApiResponse: Codable {
    var id: Int
    var title: String
    var body: String
    var userId: Int
}

struct TestApiDeleteResponse: Codable {

}


class ViewController: UIViewController {

        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        //Get action with response and Json
//        Quick.shared.getRequest(endPoint: "posts/", responseObject: [TestApiResponse].self) { (response, json, err) in
//            if let controledError = err {
//                print(controledError)
//            } else {
//                if let controledJson = json as? [[String: Any]] {
//                    print(controledJson)
//                }
//                print(response)
//            }
//        }
//
//        //Get action with response
//        Quick.shared.getRequest(endPoint: "posts/", responseObject: [TestApiResponse].self) { (response, err) in
//            if let controledError = err {
//                print(controledError)
//            } else {
//                print(response)
//            }
//        }
//
//        //Post aciton with Json Response and Json
//        Quick.shared.postRequest(url: "posts", parameters: ["title": "quickApi", "body": "quickApiBody","userId": 1], responseObject: TestApiResponse.self) { (response, json, err) in
//            if let controledError = err {
//                print(controledError)
//            } else {
//                if let controledJson = json as? [String: Any] {
//                    print(controledJson)
//                }
//                print(response)
//            }
//        }
//
//        //Post aciton with Json Response
//        Quick.shared.postRequest(url: "posts", parameters: ["title": "quickApi", "body": "quickApiBody","userId": 1], responseObject: TestApiResponse.self) { (response, err) in
//            if let controledError = err {
//                print(controledError)
//            } else {
//                print(response)
//            }
//        }
//
//        //Put aciton with Json Response and Json
//        Quick.shared.patchRequest(url: "posts/1", parameters: ["title": "quickApi"], responseObject: TestApiResponse.self) { (response, json, err) in
//            if let controledError = err {
//                print(controledError)
//            } else {
//                if let controledJson = json as? [String: Any] {
//                    print(controledJson)
//                }
//                print(response)
//            }
//        }
//
//        //Put aciton with Json Response
//        Quick.shared.patchRequest(url: "posts/1", parameters: ["title": "quickApi"], responseObject: TestApiResponse.self) { (response, err) in
//            if let controledError = err {
//                print(controledError)
//            } else {
//                print(response)
//            }
//        }
//
//        //Delete aciton with Json Response and Json
//        Quick.shared.deleteRequest(url: "posts/1", parameters: nil, responseObject: TestApiDeleteResponse.self) { (response, json, err) in
//            if let controledError = err {
//                print(controledError)
//            } else {
//                if let controledJson = json as? [String: Any] {
//                    print(controledJson)
//                }
//                print(response)
//            }
//        }
//
//        //Delete aciton with Json Response
//        Quick.shared.deleteRequest(url: "posts/1", parameters: nil, responseObject: TestApiDeleteResponse.self) { (response, err) in
//            if let controledError = err {
//                print(controledError)
//            } else {
//                print(response)
//            }
//        }
//    }
        
        
       
        Quick.shared.errorModel.setCustomError = { json, statusCode in
            if let messagea = json["test"] as? [String:Any] {
                if let text = messagea["test"] as? String {
                    return text
                } else {
                    return nil
                }
            }
            if let message = json["message"] as? [String:Any] {
                if let text = message["messageText"] as? String {
                    return text
                } else {
                    return nil
                }
            } else if let errors = json["errors"] as? [String: Any] {
                if let sub = errors["errorText"] as? String {
                    return sub
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
}

