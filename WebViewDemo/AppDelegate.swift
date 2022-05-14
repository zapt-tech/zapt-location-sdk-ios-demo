import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
                            
    var window: UIWindow?
    
    var zaptLocation:ZTLocationSDK!
    
    var locationManager: CLLocationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            if granted {
                NSLog("Notification Enabled Successfully")
            }else{
                NSLog("Notification Enable Error")
            }
        }
        
        //self.locationManager.requestWhenInUseAuthorization()
        self.zaptLocation = ZTLocationSDK(visitableId: "-ltvysf4acgzdxdhf81y")
        self.zaptLocation.start()
        self.zaptLocation.requestPermissionsBackground()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // Override point for customization after application launch.
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("enter")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("exit")

    }

    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        NSLog("didDetermineState: \(state)")
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        var stateString = "unknown"
        if state == .inside {
            stateString = "inside"
        }
        if state == .outside {
            stateString = "outside"
        }
        content.title = "Beacon Region: \(stateString)"
        content.body = "Beacon Region: \(stateString)"
        content.badge = NSNumber(value: 3)
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest.init(identifier: "beaconstate", content: content, trigger: trigger)

        center.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    

}

