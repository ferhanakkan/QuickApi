# QuickApi

<p align="center">
<img src='https://github.com/ferhanakkan/QuickApi/blob/master/QuickApi/Resources/Assetes.xcassets/AppIcon.appiconset/1024.png' width="200" />
</p>

AuthTextField allows you to easily create and validate animated textfields on the authentication screens for your applications.

[![CI Status](https://img.shields.io/travis/ferhanakkan/AuthTextField.svg?style=flat)](https://travis-ci.org/ferhanakkan/QuickApi)
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



