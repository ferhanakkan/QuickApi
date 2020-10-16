//
//  UIApplication+Extension.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 16.10.2020.
//


import UIKit

extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
}
