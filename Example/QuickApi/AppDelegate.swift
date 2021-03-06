//
//  AppDelegate.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 10/03/2020.
//  Copyright (c) 2020 Ferhan Akkan. All rights reserved.
//

import UIKit
import QuickApi

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Test api => https://jsonplaceholder.typicode.com/
        
        Quick.shared.setApiBaseUrl(url: "https://jsonplaceholder.typicode.com/") // You have to set Api Url.
        Quick.shared.timeOutTime = 10 // 10 Second. You have to set timeOutTime. İt accept seconds as Int.
        Quick.shared.showResponseJSONOnConsole = false // If you want to see your response data on console you have to set it true. It's totaly optional. It's preset false.
        Quick.shared.showLoadingIndicator = false // If you want to see loading inducator while request continues you have to set it true. It's totaly optional. It's preset false.
        Quick.shared.acceptLanguageCode = "tr" // If you want you can also add Accept language to your Http Header. You can do this actions also in another part of app. It will be saved on local database.
        Quick.shared.setToken(token: "123123") // If you want you can also add Accept language to your Http Header. You can do this actions also in another part of app. It will be saved on local database.
        Quick.shared.customErrorModel = true // For custom error models you have to active this propertie. I will explain how to use it.
        LoadingView.loadingBackgroundColor = UIColor.darkGray.withAlphaComponent(0.8) // It's preset color of main background color of Loading View it also can be changed if you prefer.
        LoadingView.loadingSubViewBackgroundColor = UIColor.lightGray // It's preset color of inducator background color of Loading View it also can be changed if you prefer.
        
        return true
    }
}

