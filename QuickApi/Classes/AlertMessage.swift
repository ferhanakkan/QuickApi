//
//  AlertMessage.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 16.10.2020.
//

import UIKit

class AlertMessage {
    
    static func messagePresent(title: String, message: String, moreButtonAction: [UIAlertAction]?, firstAlertAction: UIAlertAction? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let firstAlert = firstAlertAction {
            alert.addAction(firstAlert)
        } else {
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (_) in
            }))
        }
        
        if let actions = moreButtonAction {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        UIApplication.getPresentedViewController()?.present(alert, animated: true, completion: nil)
    }

    
}

