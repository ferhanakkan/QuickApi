# QuickApi

<p align="center">
<img src='https://github.com/ferhanakkan/QuickApi/blob/master/Example/Example/Assets.xcassets/AppIcon.appiconset/1024.png' width="200" />
</p>

QuickApi allows you to work with more than one API in your applications, without dealing with decode operations. Apart from that  allows you to solve the error handling, 401 unautehntication handling,  status code handling problems in a simplified way.  QuickApi supports GET, POST, DELETE, PUT, PATCH and also MULTİPART requests.

[![Version](https://img.shields.io/cocoapods/v/QuickApi.svg?style=flat)](https://cocoapods.org/pods/QuickApi)
[![License](https://img.shields.io/cocoapods/l/QuickApi.svg?style=flat)](https://cocoapods.org/pods/QuickApi)
[![Platform](https://img.shields.io/cocoapods/p/QuickApi.svg?style=flat)](https://cocoapods.org/pods/QuickApi)

## Features
-  Supports 3 diffrent api and custom requests.
-  Supports 3 diffrent api and custom requests for multipart.
-  Response object will decode automatically
-  Retry support for requests
-  Error Handling
-  Http Header Handling
-  Status Code Handling
-  Unauthorized Handling

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Error Handling](#error-handling)
- [Http Header Handling](#http-header-handling)
- [Status Code Handling](#status-code-handling)
- [Unauthorized Handling](#unauthorized-handling)
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
        
        Quick.shared.customRequest(full: "https://www.anyapi.com/endPoint",
                                   method: .get,
                                   parameters: ["paramName" : "param"],
                                   decodeObject: OpenWeatherResponse.self) { result in
          switch result {
          case .success(let value):
            print(value)
          case .failure(let error):
            print(error.statusCode ?? "")
            print(error.json ?? "")
          }
        }
    }
}
```

### Custom Request 

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
        
        Quick.shared.customRequest(full: "https://www.anyapi.com/endPoint",
                                   method: .get,
                                   parameters: ["paramName" : "param"],
                                   decodeObject: OpenWeatherResponse.self) { result in
          switch result {
          case .success(let value):
            print(value)
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

## Error Handling

When you want to get parameters that are not in your response models with the QuickApi, set the setCustomErrorManager(delegate: ErrorCustomizationProtocol) and setCustomErrorManagerForMultipart(delegate: ErrorCustomizationProtocol) delegates. Add the ErrorCustomizationProtocol protocol to your class. Select the parameters you want to receive from JSON and when your call request fails, your parameter will come in your error object. If you want, you can do the necessary operations when the parameters you want come from api.  It's optional to use.

```swift
import QuickApi

class QuickSettings: ErrorCustomizationProtocol {
  
  func errorCustomization(json: [String : Any]?, apiType: ApiTypes) -> Any? {
    switch apiType {
    case .primary:
      return json?["message"]
      
    case .secondary:
      return json?["status_code"]
      
    case .tertiary:
      return nil
      
    case .custom:
      return json?["status_code"]
    }
  }
}
```

## Http Header Handling

When you need to add http header for your requests with Quick API, set setHeaderCompletion(delegate: HttpCustomizationProtocols) and setHeaderCompletionForMultipart(delegate: HttpCustomizationProtocols). Add the HttpCustomizationProtocols protocol to your class. You can return http header according to your api type as return within the function. It's optional to use.

```swift
import Alamofire
import QuickApi

extension QuickSettings: HttpCustomizationProtocols {
  
  func httpHeaderCustomization(apiType: ApiTypes) -> HTTPHeaders? {
    switch apiType {
    case .primary:
      return nil
      
    case .secondary:
      return [
        "Authorization" : "Bearer anyToken",
        "Content-Type" : "application/json;charset=utf-8"
      ]
      
    case .tertiary:
      return nil
      
    case .custom:
      return nil
    }
  }
}
```

## Status Code Handling

When you want to take action according to the status code for your requests with Quick API, set setStatusCodeHandler(delegate: StatusCodeHandlerProtocol) and setStatusCodeHandlerForMultipart(delegate: StatusCodeHandlerProtocol). Add the HttpCustomizationProtocols protocol to your class. Then you can take the necessary actions according to your api type. It's optional to use.

```swift
import QuickApi

extension QuickSettings: StatusCodeHandlerProtocol {
  
  func handleStatusCodeFor(apiType: ApiTypes, statusCode: Int) {
    switch apiType {
    case .primary:
      if statusCode == 301 {
       // Do some logic stuff what you need. 
      }
      
    case .secondary:
      break
      
    case .tertiary:
      break
      
    case .custom:
      break
    }
  }
}
```

## Unauthorized Handling

Set the delegates setUnauthorized(delegate: UnauthorizedCustomizationProtocol) and setUnauthorizedForMultipart(delegate: UnauthorizedCustomizationProtocol) so that you can take action in case of your requests with 401 error code, ie unauthorized. Add the UnauthorizedCustomizationProtocol protocol to your class. After these processes, if your request receives a 401 error, this function will be triggered and you can take action according to your API type. Here you can send the required refresh token request. When your operations are completed, completion will be called and the request that received the last 401 error will be called again.

```swift
import QuickApi

class QuickSettings: UnauthorizedCustomizationProtocol {
  
  func unauthorizedCustomization(apiType: ApiTypes, completion: @escaping () -> ()) {
    switch apiType {
    case .primary:
      completion()
      
    case .secondary:
    break
      
    case .tertiary:
      break
      
    case .custom:
      break
    }
  }
}
```

## Author

Ferhan Akkan, ferhanakkan@gmail.com

## License

QuickApi is available under the MIT license. See the LICENSE file for more info.
