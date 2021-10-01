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
  
  var test: QuickSettings?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    setQuickApi()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UINavigationController(rootViewController: HomeController())
    window?.makeKeyAndVisible()
    return true
  }
  
  private func setQuickApi() {
    test = QuickSettings()
  }
}

