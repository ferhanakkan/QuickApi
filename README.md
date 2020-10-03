# QuickApi

<p align="center">
<img src='https://github.com/ferhanakkan/QuickApi/blob/master/QuickApi/Resources/Assetes.xcassets/AppIcon.appiconset/1024.png' width="200" />
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
    LoadingView.loadingBackgroundColor = UIColor.darkGray.withAlphaComponent(0.8) // It's preset color of main background color of Loading View it also can be changed if you prefer.
    LoadingView.loadingSubViewBackgroundColor = UIColor.lightGray // It's preset color of inducator background color of Loading View it also can be changed if you prefer.
    
    return true
}
```


### Quick Start

#### Programmatically usage

```swift

import UIKit
import AuthTextField

class ViewController: UIViewController {
    
    let nameTextfield = AuthField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextfield.inputType = .name
        
        self.view.addSubview(nameTextfield)
        nameTextfield.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            nameTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            nameTextfield.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextfield.heightAnchor.constraint(equalToConstant: 50)

        ])
    }

}
```

## Author

ferhanakkan, ferhanakkan@gmail.com

## License

AuthTextField is available under the MIT license. See the LICENSE file for more info.



