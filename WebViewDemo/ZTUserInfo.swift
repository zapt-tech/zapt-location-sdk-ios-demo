import Foundation

public class ZTUserInfo {
	var userId: String?
	var userName: String?
	var deviceId: String?
	var categories: NSMutableDictionary?
	
	public init() {
		userId = getUserId()
		userName = getUserName()
		deviceId = getDeviceId()
		categories = getCategories()
	}
	
	public func getUserId() -> String {
		if userId == nil {
			userId = uniqueAppInstanceIdentifier()
		}
		return userId!
	}
	
	public func getUserName() -> String? {
		return userName
	}
	
	public func getDeviceId() -> String {
		if deviceId == nil {
			#if targetEnvironment(simulator)
				let platform = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"]
			#else
				var size: size_t = 0
				sysctlbyname("hw.machine", nil, &size, nil, 0)
				var machine = [CChar](repeating: 0, count: Int(size))
				sysctlbyname("hw.machine", &machine, &size, nil, 0)
				let platform = String(cString: machine)
			#endif
			deviceId = platform
		}
		return deviceId!
	}
	
	public func getCategories() -> NSMutableDictionary {
		if categories == nil {
			categories = NSMutableDictionary()
		}
		return categories!
	}
	
	func uniqueAppInstanceIdentifier() -> String {
		let userDefaults = UserDefaults.standard
		let UUID_KEY = "CDVUUID"
		
		var appUUID = userDefaults.string(forKey: UUID_KEY)
		if appUUID == nil {
			let uuid = UUID()
			let uuidStr = uuid.uuidString
			userDefaults.set(uuidStr, forKey: UUID_KEY)
			userDefaults.synchronize()
			appUUID = uuidStr
		}
		
		return appUUID!
	}
	
	public func commit() {
		let userJSON = toJSON()
		let defaults = UserDefaults.standard
		defaults.setValue(userJSON, forKey: "ZAPT_USER_INFO")
		defaults.synchronize()
	}
	
	public static func recover() -> ZTUserInfo {
		let defaults = UserDefaults.standard
		let userJSON = defaults.string(forKey: "ZAPT_USER_INFO") ?? ""
		let userInfo = ZTUserInfo()
		
		guard let userData = userJSON.data(using: .utf8),
			  let jsonObject = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: Any] else {
			return userInfo
		}
		
		userInfo.userId = jsonObject["userId"] as? String
		userInfo.userName = jsonObject["userName"] as? String
		userInfo.deviceId = jsonObject["deviceId"] as? String
		userInfo.categories = jsonObject["categories"] as? NSMutableDictionary
		
		return userInfo
	}
	
	public func toJSON() -> String? {
		var dict = [String: Any]()
		
		dict["userId"] = getUserId()
		dict["userName"] = getUserName()
		dict["deviceId"] = getDeviceId()
		dict["categories"] = getCategories()
		
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
			return String(data: jsonData, encoding: .utf8)
		} catch {
			print("Error: \(error.localizedDescription)")
			return nil
		}
	}
}
