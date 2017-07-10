//
//  AppDelegate.swift
//  Scroll
//
//  Created by Jae Young Choi on 2017. 6. 28..
//  Copyright © 2017년 Appcid. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var scrollViewController: ScrollViewController!
        
        if let nc = window?.rootViewController as? UINavigationController, let vc = nc.topViewController as? ScrollViewController {
            scrollViewController = vc
        } else if let vc = window?.rootViewController as? ScrollViewController {
            scrollViewController = vc
        }
        
        scrollViewController.contentView = UIImageView(image: UIImage(named: "sample.jpg"))
        scrollViewController.fitScale = 0.8
        scrollViewController.margins = 100
        
        return true
    }

}

