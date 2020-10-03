//
//  ViewController.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 10/03/2020.
//  Copyright (c) 2020 Ferhan Akkan. All rights reserved.
//

import UIKit
import QuickApi

struct Test: Decodable {
    var a: Int
}

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        Quick.shared.acceptLanguageCode = "as"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

