//
//  Copyright (c) 2024 Zapt Tech. All rights reserved.
//

import UIKit
import ZaptLocationSDKSwiftFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    
    var zaptSDK:ZTLocationSDK!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        zaptSDK = ZTLocationSDK(visitableId: "-ltvysf4acgzdxdhf81y")
        zaptSDK.start()
        return true
    }

}

