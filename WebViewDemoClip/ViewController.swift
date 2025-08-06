//
//  ViewController.swift
//  WebViewDemoClip
//
//  Created by Bruno Carneiro on 05/05/25.
//  Copyright © 2025 Ravi Shankar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate  {
	
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

			let request = URLRequest(url: finalURL!)
			webView.delegate = self
			webView.loadRequest(request)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func appendQueryParameters(from sourceURL: String, to destinationURL: String) -> String {
		guard let sourceComponents = URL(string: sourceURL),
			  let query = sourceComponents.query,
			  !query.isEmpty else {
			return destinationURL
		}

		// Verifica se a URL base já tem "?"
		let separator = destinationURL.contains("?") ? "&" : "?"
		return destinationURL + separator + query
	}

}

