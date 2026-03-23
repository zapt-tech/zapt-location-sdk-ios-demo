//
//  ViewController.swift
//  WebViewDemo
//
//  Created by Ravi Shankar on 08/07/14.
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit
import WebKit

final class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        let zaptLocation = appDelegate.zaptLocation
        
        webView.navigationDelegate = self
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        zaptLocation?.attachWebViewBridges(webView)

        let url = URL(string: zaptLocation?.getMapLink() ?? "")
        let request = URLRequest(url: url!)
        webView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func doRefresh(_: AnyObject) {
        webView.reload()
    }
    
    @IBAction func goBack(_: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func goForward(_: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func stop(_: AnyObject) {
        webView.stopLoading()
    }

    deinit {
        appDelegate.zaptLocation?.detachWebViewBridges()
    }
}
