//
//  AppDelegate.swift
//  Example
//
//  Created by Ferhan Akkan on 29.09.2021.
//

import UIKit
import QuickApi

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
    return true
  }
  
  private func setQuickApi() {
    Quick.shared.setBaseUrl("https://jsonplaceholder.typicode.com/")
  }
}

