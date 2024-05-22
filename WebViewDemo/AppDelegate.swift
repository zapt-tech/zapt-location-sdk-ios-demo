//
//  AppDelegate.swift
//  WebViewDemo
//
//  Created by Ravi Shankar on 08/07/14.
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit
import ZaptLocationSDKSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
//    var zaptLocation:ZTLocationSDK!
    
    
    
    var zaptSDK:ZTLocationSDK!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //self.locationManager.requestWhenInUseAuthorization()
//        self.zaptLocation = ZTLocationSDK(visitableId: "-nzsg4lxxn8h8vjsfi-c")
//        self.zaptLocation.start()
        // Override point for customization after application launch.
        zaptSDK = ZTLocationSDK(visitableId: "-ldbpd2phzmsfhb9-9on")
        zaptSDK.start()
        return true
    }

}

