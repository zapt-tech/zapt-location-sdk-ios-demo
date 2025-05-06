import Foundation

class ZTLogger {
	var debugLogEnabled: Bool = true
	
	func debugLog(_ format: String, _ args: CVarArg...) {
		guard debugLogEnabled else { return }
		
		let msg = String(format: format, arguments: args)
		print(msg)
	}
}
