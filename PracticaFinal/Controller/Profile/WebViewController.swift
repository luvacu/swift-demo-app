//
//  WebViewController.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 21/11/14.
//
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = NSURL(string: "https://github.com/luvacu/swift-demo-app") {
            self.webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    // MARK: -
}
