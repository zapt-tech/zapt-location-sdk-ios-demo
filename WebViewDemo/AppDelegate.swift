//
//  AppDelegate.swift
//  WebViewDemo
//
//  Created by Ravi Shankar on 08/07/14.
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    var zaptLocation:ZTLocationSDK!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //self.locationManager.requestWhenInUseAuthorization()
        self.zaptLocation = ZTLocationSDK(visitableId: "-ltvysf4acgzdxdhf81y")
        self.zaptLocation.start()
        // Override point for customization after application launch.
        return true
    }

}

