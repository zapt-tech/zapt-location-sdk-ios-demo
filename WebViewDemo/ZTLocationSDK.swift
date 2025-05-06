import CoreLocation

let ZAPT_WEB_ENDPOINT = "https://app.zapt.tech/#/map"

let TIME_TO_SYNC_ANALYTICS: Double = 30 // in s
let TIME_TO_SYNC_POSITIONING: Double = 1 // in s

public class ZTLocationSDK: NSObject, CLLocationManagerDelegate {
	var visitableId: String
	var disableSyncing: Bool = false
	var debugLogEnabled: Bool = false
	var disableSyncingForPositioning: Bool = false
	var disableSyncingForAnalytics: Bool = false
	var lastSync: TimeInterval = 0
	var locationManager: CLLocationManager!
	var notifier: ZTHttpService!
	var queue: OperationQueue!
	var logger: ZTLogger

	public init(visitableId: String) {
		self.visitableId = visitableId
		self.disableSyncing = false
		self.disableSyncingForPositioning = false
		self.disableSyncingForAnalytics = false
		self.lastSync = 0
		logger = ZTLogger()
	}

	public func start() {
		initialize()
	}
	
	public func initialize() {
		debugLogEnabled = true
		notifier = ZTHttpService(visitableId: visitableId, logger: logger)
		initEventQueue()
		initLocationManager()
		notifier.createInitSDKRequest(disableSyncingForAnalytics: disableSyncingForAnalytics)
	}

	public func stop() {
		if #available(iOS 13.0, *) {
			let region = CLBeaconRegion(uuid: UUID(uuidString: "0428C59E-25B7-4E9D-B3CD-D126A46E6E9D")!, identifier: "ZAPT_TECH")
			locationManager.stopRangingBeacons(in: region)
		} else {
			let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "0428C59E-25B7-4E9D-B3CD-D126A46E6E9D")!, identifier: "ZAPT_TECH")
			locationManager.stopRangingBeacons(in: region)
		}
	}

	public func requestPermissions() {
		locationManager.requestWhenInUseAuthorization()
	}

	public func requestPermissionsBackground() {
	}

	public func getMapLink() -> String? {
		let userInfo = ZTUserInfo.recover()
		let userId = userInfo.getUserId()
		let deviceId = userInfo.getDeviceId()
		let linkWithVisitable = ZAPT_WEB_ENDPOINT + "?splash=false&bottomNavigation=false&placeId=" + visitableId
		let linkWithUserId = linkWithVisitable + "&userId=" + userId
		let linkWithDeviceId = linkWithUserId + "&deviceId=" + deviceId
		return linkWithDeviceId
	}

	public func getInterestLink(interestId: String) -> String? {
		guard let mapLink = getMapLink() else { return nil }
		return mapLink + "&interestId=" + interestId
	}



	func initLocationManager() {
		locationManager = CLLocationManager()
		locationManager.delegate = self
	}

	func initEventQueue() {
		queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1 // Don't hit the DOM too hard.
	}
	
	func mapOfBeaconRegion(_ region: CLBeaconRegion) -> [String: Any] {
		var dict = [String: Any]()
		dict["uuid"] = region.proximityUUID.uuidString
		
		if let major = region.major {
			dict["major"] = major
		}
		
		if let minor = region.minor {
			dict["minor"] = minor
		}
		
		return dict
	}
		
	func mapOfBeacon(_ beacon: CLBeacon) -> [String: Any] {
		var dict = [String: Any]()
		
		// uuid
		let uuid = beacon.proximityUUID.uuidString
		dict["uuid"] = uuid
		
		// proximity
		let proximityString = proximityAsString(beacon.proximity)
		dict["proximity"] = proximityString
		
		// major
		dict["major"] = beacon.major
		
		// minor
		dict["minor"] = beacon.minor
		
		// rssi
		let rssi = NSNumber(value: beacon.rssi)
		dict["rssi"] = rssi
		
		// accuracy is a rough estimate of distance in metres. capped to two decimal places
		let accuracy = NSNumber(value: round(100 * beacon.accuracy) / 100)
		dict["accuracy"] = accuracy
		
		return dict
	}
	
	func proximityAsString(_ proximity: CLProximity) -> String {
		let dict: [CLProximity: String] = [.near: "ProximityNear",
											.far: "ProximityFar",
											.immediate: "ProximityImmediate",
											.unknown: "ProximityUnknown"]
		return dict[proximity] ?? "Unknown"
	}

	func startRangingBeaconsInRegion() {
		if #available(iOS 13.0, *) {
			let region = CLBeaconRegion(uuid: UUID(uuidString: "0428C59E-25B7-4E9D-B3CD-D126A46E6E9D")!, identifier: "ZAPT_TECH")
			locationManager.startRangingBeacons(in: region)
		} else {
			let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "0428C59E-25B7-4E9D-B3CD-D126A46E6E9D")!, identifier: "ZAPT_TECH")
			locationManager.startRangingBeacons(in: region)
		}
	}

	func startMonitoringForRegion() {
		if #available(iOS 13.0, *) {
			let region = CLBeaconRegion(uuid: UUID(uuidString: "0428C59E-25B7-4E9D-B3CD-D126A46E6E9D")!, identifier: "ZAPT_TECH")
			let proximityRegion = CLBeaconRegion(uuid: UUID(uuidString: "92ed3fd4-f465-11ec-b939-0242ac120002")!, identifier: "ZAPT_TECH_PROXIMITY")
			locationManager.startMonitoring(for: region)
			locationManager.startMonitoring(for: proximityRegion)
		} else {
			let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "0428C59E-25B7-4E9D-B3CD-D126A46E6E9D")!, identifier: "ZAPT_TECH")
			let proximityRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "92ed3fd4-f465-11ec-b939-0242ac120002")!, identifier: "ZAPT_TECH_PROXIMITY")
			locationManager.startMonitoring(for: region)
			locationManager.startMonitoring(for: proximityRegion)
		}
	}

	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		logger.debugLog("ZAPT SDK didFailWithError: \(error)")
	}
	
	public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
		logger.debugLog("ZAPT SDK didDetermineState for region: \(region)")
	}
		
	public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		queue.addOperation {
			self.startRangingBeaconsInRegion()
			/*
			 var dict = [String: Any]()
			 dict["eventType"] = self.jsCallbackNameForSelector(#selector(self.locationManager(_:didEnter:)))
			 dict["region"] = self.mapOfRegion(region)
			 
			 let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: dict)
			 pluginResult?.setKeepCallbackAsBool(true)
			 return pluginResult
			 */
		}
	}
		
	public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		queue.addOperation {
			self.logger.debugLog("ZAPT SDK didExitRegion: \(region.identifier)")
		}
	}
		
	public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
		queue.addOperation {
			self.logger.debugLog("ZAPT SDK didStartMonitoringForRegion: \(region)")
		}
	}
		
	public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
		queue.addOperation {
			self.logger.debugLog("ZAPT SDK monitoringDidFailForRegion: \(error.localizedDescription)")
		}
	}
		
	public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
		if beacons.count > 0 && !disableSyncing && (!disableSyncingForPositioning || !disableSyncingForAnalytics) {
			var beaconsMapsArray = [[String: Any]]()
			for beacon in beacons {
				let dictOfBeacon = mapOfBeacon(beacon)
				beaconsMapsArray.append(dictOfBeacon)
			}
			
			queue.addOperation {
				self.logger.debugLog("ZAPT SDK didRangeBeacons: \(beacons)")
				
				var dict = [String: Any]()
				dict["beacons"] = beaconsMapsArray
				
				let timeInSeconds = Date().timeIntervalSince1970
				var intervalToSync: TimeInterval = 0
				if self.disableSyncingForPositioning {
					intervalToSync = TIME_TO_SYNC_ANALYTICS
				} else {
					intervalToSync = TIME_TO_SYNC_POSITIONING
				}
				
				if timeInSeconds - self.lastSync >= intervalToSync {
					self.logger.debugLog("ZAPT SDK syncing")
					self.lastSync = timeInSeconds
					self.notifier.createMeasurementsRequest(beacons: dict, disableSyncingForPositioning: self.disableSyncingForPositioning, disableSyncingForAnalytics: self.disableSyncingForAnalytics)
				}
			}
		}
	}
		
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		print("didChangeAuthorizationStatus")
		
		logger.debugLog("ZAPT SDK didChangeAuthorizationStatus: \(status.rawValue)")
		
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			startRangingBeaconsInRegion()
			startMonitoringForRegion()
		} else {
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	

	// Implement other CLLocationManagerDelegate methods

	// Utility methods and other implementations...
}
