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
								
	override func viewDidLoad() {
		super.viewDidLoad()
		let zaptLocation = appDelegate.zaptSDK
		
		let url = NSURL(string: zaptLocation?.getMapLink() ?? "")
		let request = NSURLRequest(url: url! as URL)
		
		webView.delegate = self
		webView.loadRequest(request as URLRequest)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

