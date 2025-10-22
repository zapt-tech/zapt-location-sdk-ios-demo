import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

	var webView: WKWebView!
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var initialURL: URL?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard
			let blackTopInset = view.subviews.first(where: { $0.accessibilityIdentifier == "TopBlackView" || $0.restorationIdentifier == "TopBlackView" }),
			let blackBottomInset = view.subviews.first(where: { $0.accessibilityIdentifier == "BottomBlackView" || $0.restorationIdentifier == "BottomBlackView" })
		else {
			print("⚠️ Não encontrou as bordas pretas no storyboard.")
			return
		}

		// Inicializa WKWebView programaticamente
		let config = WKWebViewConfiguration()
		webView = WKWebView(frame: self.view.bounds, configuration: config)
		webView.navigationDelegate = self
		webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.insertSubview(webView, belowSubview: blackTopInset)
		webView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: blackTopInset.bottomAnchor),
			webView.bottomAnchor.constraint(equalTo: blackBottomInset.topAnchor),
			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])

		// Montagem da URL final
		let zaptLocation = appDelegate.zaptSDK
		let baseURL = URL(string: zaptLocation?.getMapLink() ?? "")
		var finalURL: URL?

		if let baseURL = baseURL {
			if let sourceURL = initialURL {
				finalURL = URL(string: appendQueryParameters(from: sourceURL.absoluteString, to: baseURL.absoluteString + "p=3"))
			} else {
				finalURL = baseURL
			}

			if let finalURL = finalURL {
				let request = URLRequest(url: finalURL)
				webView.load(request)
			}
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

	// MARK: - WKNavigationDelegate
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
				 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

		guard let url = navigationAction.request.url else {
			decisionHandler(.cancel)
			return
		}

		// Detecta se o link é externo e abre no Safari
		if navigationAction.navigationType == .linkActivated {
			if !isInternalURL(url) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
				decisionHandler(.cancel)
				return
			}
		}

		decisionHandler(.allow)
	}

	func isInternalURL(_ url: URL) -> Bool {
		guard let host = url.host else { return false }
		return host.contains("app.zapt.tech") || host.contains("maps.zapt.tech") || host.contains("firebase")
	}
}
