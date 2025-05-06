//
//  Copyright (c) 2024 Zapt Tech. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    
	var zaptSDK:ZTLocationSDK!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		zaptSDK = ZTLocationSDK(visitableId: "-ol4g6xderbaq83rmhve")
        zaptSDK.start()
        return true
    }

}

