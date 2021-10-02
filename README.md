# QuickApi

<p align="center">
<img src='https://github.com/ferhanakkan/QuickApi/blob/master/Example/Example/Assets.xcassets/AppIcon.appiconset/1024.png' width="200" />
</p>

QuickApi allows you to work with more than one API in your applications, without dealing with decode operations. Apart from that  allows you to solve the error handling, 401 unautehntication handling,  status code handling problems in a simplified way.  QuickApi supports GET, POST, DELETE, PUT, PATCH and also MULTİPART requests.

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

### Cocoapods

Jake is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QuickApi'
```

### Swift Package Manager

1. File > Swift Packages > Add Package Dependency
2. Add `https://github.com/ferhanakkan/QuickApi.git`

_OR_

Update `dependencies` in `Package.swift`
```swift
dependencies: [
    .package(url: "https://github.com/ferhanakkan/QuickApi.git", .upToNextMajor(from: "1.0.0"))
]
```


## Usage 

### Functions

  Some funtctions to set QuickApi.

```swift

  // Common settings for General and Multipart requests.
  
  Quick.shared.cancelAllRequests() // Cancel all requests.
  Quick.shared.showResponseInDebug(_ isEnable: Bool) // It allows the incoming response to be seen on the debug.
  Quick.shared.setTimeOut(_ time: Int) // Sets the timeout for the discarded request.
  Quick.shared.setMaxNumberOfRetry(_ count: Int) // It determines how many times it will be repeated if the request is unsuccessful.
  
  Quick.shared.setApiBaseUrlWith(apiType: ApiTypes, apiUrl: String) // Sets api url.
  Quick.shared.setCustomErrorManager(delegate: ErrorCustomizationProtocol) // Set error delegate for network requests.
  Quick.shared.setHeaderCompletion(delegate: HttpCustomizationProtocols)  // Set header delegate for network requests.
  Quick.shared.setUnauthorized(delegate: UnauthorizedCustomizationProtocol)  // Set unauthorized delegate for network requests.
  Quick.shared.setStatusCodeHandler(delegate: StatusCodeHandlerProtocol)  // Set status delegate for network requests.
  
  Quick.shared.get(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>)   // Get
  Quick.shared.post(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>)   // Post
  Quick.shared.put(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>)   // Put
  Quick.shared.patch(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>)   // Patch
  Quick.shared.delete(url: String, parameters: Parameters? = nil, decodeObject: T.Type, apiType: ApiTypes = .primary, completion: @escaping GenericResponseCompletion<T>)   // Delete
  Quick.shared.customRequest(full: String, header: HTTPHeaders? = nil, method: HTTPMethod, parameters: Parameters?, decodeObject: T.Type, completion: @escaping GenericResponseCompletion<T>) // Custom request you can create request as you wish.
  
  
  Quick.shared.setApiBaseUrlWithForMultipart(apiType: ApiTypes, apiUrl: String) // Sets api url for multipart.
  Quick.shared.setCustomErrorManagerForMultipart(delegate: ErrorCustomizationProtocol) // Set error delegate for network requests for multipart.
  Quick.shared.setHeaderCompletionorMultipart(delegate: HttpCustomizationProtocols) // Set header delegate for network requests for multipart.
  Quick.shared.setUnauthorizedorMultipart(delegate: UnauthorizedCustomizationProtocol) // Set unauthorized delegate for network requests for multipart.
  Quick.shared.setStatusCodeHandlerorMultipart(delegate: StatusCodeHandlerProtocol)  // Set status delegate for network requests for multipart.
  
  
  Quick.shared.upload(url: String, method: HTTPMethod, parameters: [String: Any], datas: [MultipartDataModel], decodeObject: T.Type, apiType: ApiTypes, completion: @escaping GenericResponseCompletion<T>) // Multipart
  Quick.shared.customMultipartUploadRequest(fullUrl: String, header: HTTPHeaders, method: HTTPMethod, parameters: [String: Any], datas: [MultipartDataModel], decodeObject: T.Type, completion: @escaping GenericResponseCompletion<T>)  // You can create multipart request as you wish.
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

class TestController: UIViewController {

        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Quick.shared.setMaxNumberOfRetry(3)
        Quick.shared.setTimeOut(10)
        Quick.shared.showResponseInDebug(true)
        
        Quick.shared.setUnauthorized(delegate: self)
        Quick.shared.setHeaderCompletion(delegate: self)
        Quick.shared.setCustomErrorManager(delegate: self)
        Quick.shared.setStatusCodeHandler(delegate: self)
        
        Quick.shared.setApiBaseUrlWith(apiType: .primary, apiUrl: "http://api.anyapi.org/")
        
        //While you are call request there is a parameter named apiType it's setted .primary as default. When you call request 
        //for second api you have to set it as apiType: .secondary .
        Quick.shared.get(url: "anyEndPoint",
                         parameters: nil,
                         decodeObject: TestApiResponse.self) { result in
          switch result {
          case .success(let value):
            print(value) // Decodade value as you give decodeObject type.
          case .failure(let error):
            print(error.statusCode ?? "")
            print(error.json ?? "")
          }
        }
    }
}
```

### QuickApi Error Object

```swift

struct QuickError<T: Decodable>: Error {
  public let alamofireError: AFError //When error occured in request you can get alamofire error as usual.
  public let response: T? // Your decode object if decoding avaliable.
  public let customErrorMessage: Any? // Custom error message which you want to get from json when error occured.
  public let json: [String : Any]? // Json response .
  public let data: Data? // Response data.
  public let statusCode: Int? // Status code of request.
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
