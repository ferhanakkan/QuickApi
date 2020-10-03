//
//  LoadingView.swift
//  QuickApi
//
//  Created by Ferhan Akkan on 3.10.2020.
//

import UIKit

public class LoadingView {
    
    private static var subView: UIView?
    private static var currentView : UIView?
    private static var mainViewTarget : UIView?
    private static var loadingSubView : UIView?
    
    public static var loadingBackgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
    public static var loadingSubViewBackgroundColor = UIColor.lightGray
    
    public static func show() {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            print("current screen error")
            return
        }
        show(currentMainWindow)
    }
    
    static func show(_ mainView : UIView) {

        let subView = UIView()
        subView.backgroundColor = loadingBackgroundColor
        mainView.addSubview(subView)
        mainView.bringSubviewToFront(subView)
        
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            subView.topAnchor.constraint(equalTo: mainView.topAnchor),
            subView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
        ])
 
        loadingSubView = UIView()
        subView.addSubview(loadingSubView!)
        loadingSubView?.cornerRadius = 15
        loadingSubView?.backgroundColor = loadingSubViewBackgroundColor
        
        NSLayoutConstraint.activate([
            loadingSubView!.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            loadingSubView!.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            loadingSubView!.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.2),
            loadingSubView!.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.2),
        ])
        
        let loadingInducator = UIActivityIndicatorView()
        loadingSubView?.addSubview(loadingInducator)
        
        NSLayoutConstraint.activate([
            loadingInducator.leadingAnchor.constraint(equalTo: loadingInducator.leadingAnchor, constant: 20),
            loadingInducator.trailingAnchor.constraint(equalTo: loadingInducator.trailingAnchor, constant: -20),
            loadingInducator.centerXAnchor.constraint(equalTo: loadingInducator.centerXAnchor),
            loadingInducator.centerYAnchor.constraint(equalTo: loadingInducator.centerYAnchor),
        ])
        
        loadingInducator.startAnimating()

        currentView = subView
        mainViewTarget = mainView
    }
    
    public static func hide() {
        if currentView != nil {
            currentView?.removeFromSuperview()
            currentView =  nil
            mainViewTarget = nil
            loadingSubView?.removeFromSuperview()
            loadingSubView = nil
            subView?.removeFromSuperview()
            subView = nil
        }
    }
}

