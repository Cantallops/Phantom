//
//  WebViewController.swift
//  Phantom
//
//  Created by Alberto Cantallops on 30/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    private var webView: WKWebView!

    private var url: URL! {
        didSet {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
    }

    func load(url: URL) {
        self.url = url
    }
}
