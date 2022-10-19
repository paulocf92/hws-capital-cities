//
//  WikiPageController.swift
//  CapitalCities
//
//  Created by Paulo Filho on 19/10/22.
//

import WebKit
import UIKit

class WikiPageController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var capital: String!
    var websites = ["en.wikipedia.org", "en.m.wikipedia.org"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://en.wikipedia.org/wiki/" + capital)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host() {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }
}
