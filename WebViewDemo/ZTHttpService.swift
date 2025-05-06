import Foundation

let INITSDK_ENDPOINT = "https://us-central1-zapt-bigdata.cloudfunctions.net/initializeSDK"
let MEASUREMENTS_ENDPOINT = "https://us-central1-zapt-backend.cloudfunctions.net/publish"
let EXIT_REGION_ENDPOINT = "https://us-central1-zapt-bigdata.cloudfunctions.net/visitExit"

class ZTHttpService {
	var visitableId: String
	var logger: ZTLogger?
	
	init(visitableId: String, logger: ZTLogger) {
		self.visitableId = visitableId
		self.logger = logger
	}
	
	func createExitRequest(userId: String) {
		// TODO
	}
	
	func createInitSDKRequest(disableSyncingForAnalytics: Bool) {
		guard !disableSyncingForAnalytics else { return }
		
		logger?.debugLog("createInitSDKRequest invoked")
		
		let user = ZTUserInfo.recover()
		
		var body: [String: Any] = ["visitable": visitableId]
		body["userId"] = user.getUserId()
		body["deviceId"] = user.getDeviceId()
		body["context"] = "sdk"
		
		guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else { return }
		
		var request = URLRequest(url: URL(string: INITSDK_ENDPOINT)!)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse, error == nil else {
				self.logger?.debugLog("Error sending data to \(MEASUREMENTS_ENDPOINT), HTTP status code \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
				return
			}
			
			self.logger?.debugLog("Success sending \(MEASUREMENTS_ENDPOINT), HTTP status code \(httpResponse.statusCode)")
		}
		
		task.resume()
	}
	
	func createMeasurementsRequest(beacons: [String: Any], disableSyncingForPositioning: Bool, disableSyncingForAnalytics: Bool) {
		logger?.debugLog("BeaconNotifier.ddidRangeBeacons invoked")
		
		let user = ZTUserInfo.recover()
		
		var body: [String: Any] = ["measurements": beacons]
		
		body["visitableId"] = visitableId
		
		body["device"] = user.getDeviceId()
		body["userId"] = user.getUserId()
		body["userCategories"] = user.getCategories()
		
		if let userName = user.getUserName() {
			body["userName"] = userName
		}
		
		body["disableSyncingForPositioning"] = disableSyncingForPositioning
		body["disableSyncingForAnalytics"] = disableSyncingForAnalytics
		
		guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else { return }
		
		var request = URLRequest(url: URL(string: MEASUREMENTS_ENDPOINT)!)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse, error == nil else {
				self.logger?.debugLog("Error sending data to \(MEASUREMENTS_ENDPOINT), HTTP status code \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
				return
			}
			
			self.logger?.debugLog("Success sending \(MEASUREMENTS_ENDPOINT), HTTP status code \(httpResponse.statusCode)")
		}
		
		task.resume()
	}
}
