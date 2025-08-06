import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet var webView: UIWebView!
	let appDelegate = UIApplication.shared.delegate as! AppDelegate

	var initialURL: URL?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let zaptLocation = appDelegate.zaptSDK
		let baseURL = URL(string: zaptLocation?.getMapLink() ?? "")
		var finalURL: URL?

		if let baseURL = baseURL {
			if let sourceURL = initialURL {
				finalURL = URL(string: appendQueryParameters(from: sourceURL.absoluteString, to: baseURL.absoluteString))
			} else {
				finalURL = baseURL
			}

			webView.delegate = self
			let request = URLRequest(url: finalURL!)
			webView.loadRequest(request)
		}
	}

	func appendQueryParameters(from sourceURL: String, to destinationURL: String) -> String {
		guard let sourceComponents = URL(string: sourceURL),
			  let query = sourceComponents.query,
			  !query.isEmpty else {
			return destinationURL
		}

		let separator = destinationURL.contains("?") ? "&" : "?"
		return destinationURL + separator + query
	}

	// MARK: - UIWebViewDelegate
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
		guard let url = request.url else { return false }

		// Detecta se é uma tentativa de "window.open" de um link externo
		if navigationType == .linkClicked || navigationType == .other {
			if !isInternalURL(url) {
				// Abre no navegador externo (Safari)
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
				return false
			}
		}

		return true
	}

	func isInternalURL(_ url: URL) -> Bool {
		guard let host = url.host else { return false }
		return host.contains("app.zapt.tech") || host.contains("maps.zapt.tech") || host.contains("firebase")
	}
}
