# QuickApi

<p align="center">
<img src='https://github.com/ferhanakkan/QuickApi/blob/master/QuickApi/Resources/Assets.xcassets/AppIcon.appiconset/1024.png' width="200" />
</p>

QuickApi allows you to easily create a network layer. You can use it for your GET, POST, DELETE, PUT, PATCH and also MULTİPART actions. 

[![CI Status](https://img.shields.io/travis/ferhanakkan/QuickApi.svg?style=flat)](https://travis-ci.org/ferhanakkan/QuickApi)
[![Version](https://img.shields.io/cocoapods/v/QuickApi.svg?style=flat)](https://cocoapods.org/pods/QuickApi)
[![License](https://img.shields.io/cocoapods/l/QuickApi.svg?style=flat)](https://cocoapods.org/pods/QuickApi)
[![Platform](https://img.shields.io/cocoapods/p/QuickApi.svg?style=flat)](https://cocoapods.org/pods/QuickApi)

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Author](#author)
- [License](#license)

## Requirements
- iOS 11+
- Swift 5+
- Xcode 10+

## Installation

QuickApi is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QuickApi'
```

## Usage 

### Set QuickApi

Firstly you have to set Quick api properties.

```


func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    Quick.shared.setApiBaseUrl(url: "https://www.yourApi.com/") // You have to set Api Url.
    Quick.shared.timeOutTime = 10 // 10 Second. You have to set timeOutTime. İt accept seconds as Int.
    Quick.shared.showResponseJSONOnConsole = true // If you want to see your response data on console you have to set it true. It's totaly optional. It's preset false.
    Quick.shared.showLoadingInducator = true // If you want to see loading inducator while request continues you have to set it true. It's totaly optional. It's preset false.
    Quick.shared.acceptLanguageCode = "tr" // If you want you can also add Accept language to your Http Header.
    Quick.shared.showAlertMessageInError = true // You can show your respose errors as alert message to your client.It's preset false
    Quick.shared.messageTitle = "Error" // You can also change alert message title.
    Quick.shared.buttonTitle = "Ok" // You can also change alert message button title.
    You can do this actions also in another part of app. It will be saved on local database. It's preset nil
    Quick.shared.setToken(token: "123123") // If you want you can also add Token to your Http Header. You can do this actions also in another part of app. It will be saved on local database. It's preset nil
    LoadingView.loadingBackgroundColor = UIColor.darkGray.withAlphaComponent(0.8) // It's preset color of main background color of Loading View it also can be changed if you prefer. It's preset UIColor.darkGray.withAlphaComponent(0.8)
    LoadingView.loadingSubViewBackgroundColor = UIColor.lightGray // It's preset color of inducator background color of Loading View it also can be changed if you prefer. It's preset UIColor.lightGray
    
    return true
}
```


### Quick Start



```swift

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
        
        //Get action with response and Json
        Quick.shared.getRequest(endPoint: "posts/", responseObject: [TestApiResponse].self) { (response, json, err) in
            if let controledError = err {
                print(controledError)
            } else {
                if let controledJson = json as? [[String: Any]] {
                    print(controledJson)
                }
                print(response)
            }
        }

        //Get action with response
        Quick.shared.getRequest(endPoint: "posts/", responseObject: [TestApiResponse].self) { (response, err) in
            if let controledError = err {
                print(controledError)
            } else {
                print(response)
            }
        }

        //Post aciton with Json Response and Json
        Quick.shared.postRequest(url: "posts", parameters: ["title": "quickApi", "body": "quickApiBody","userId": 1], responseObject: TestApiResponse.self) { (response, json, err) in
            if let controledError = err {
                print(controledError)
            } else {
                if let controledJson = json as? [String: Any] {
                    print(controledJson)
                }
                print(response)
            }
        }

        //Post aciton with Json Response
        Quick.shared.postRequest(url: "posts", parameters: ["title": "quickApi", "body": "quickApiBody","userId": 1], responseObject: TestApiResponse.self) { (response, err) in
            if let controledError = err {
                print(controledError)
            } else {
                print(response)
            }
        }
        
        //Put aciton with Json Response and Json
        Quick.shared.patchRequest(url: "posts/1", parameters: ["title": "quickApi"], responseObject: TestApiResponse.self) { (response, json, err) in
            if let controledError = err {
                print(controledError)
            } else {
                if let controledJson = json as? [String: Any] {
                    print(controledJson)
                }
                print(response)
            }
        }

        //Put aciton with Json Response
        Quick.shared.patchRequest(url: "posts/1", parameters: ["title": "quickApi"], responseObject: TestApiResponse.self) { (response, err) in
            if let controledError = err {
                print(controledError)
            } else {
                print(response)
            }
        }
        
        //Delete aciton with Json Response and Json
        Quick.shared.deleteRequest(url: "posts/1", parameters: nil, responseObject: TestApiDeleteResponse.self) { (response, json, err) in
            if let controledError = err {
                print(controledError)
            } else {
                if let controledJson = json as? [String: Any] {
                    print(controledJson)
                }
                print(response)
            }
        }

        //Delete aciton with Json Response
        Quick.shared.deleteRequest(url: "posts/1", parameters: nil, responseObject: TestApiDeleteResponse.self) { (response, err) in
            if let controledError = err {
                print(controledError)
            } else {
                print(response)
            }
        }
    }
}
```

### Error Handling

As Quick, we found the biggest problem in generic services, to deal with the error, by leaving the solution to you. Normally, if Quick.shared.customErrorModel = false as the QuickApi library, we give an error return as the model you have given can be decoded or not. However, if you set your own error model as custom, error messages will return to you as errors, except 200-300 returned from the service. Let's look at an example ... 

```swift
import UIKit
import QuickApi

class ViewController: UIViewController {

        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
        //You can do this action where ever you want!!!
       
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
```

## Author

ferhanakkan, ferhanakkan@gmail.com

## License

QuickApi is available under the MIT license. See the LICENSE file for more info.



