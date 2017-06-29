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
        
        if let vc = window?.rootViewController as? ScrollViewController {
            vc.contentView = UIImageView(image: UIImage(named: "sample.jpg"))
        }
        return true
    }

}

