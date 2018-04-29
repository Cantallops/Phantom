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
    private var progressView: UIProgressView!

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
        webView.navigationDelegate = self
        view = webView

        setUpProgressBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))

        _ = webView.observe(\.estimatedProgress) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func load(url: URL) {
        self.url = url
    }

    private func setUpProgressBar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = Color.tint

        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        if let nav = navigationController {
            nav.navigationBar.addSubview(progressView)
            let navigationBarBounds = nav.navigationBar.bounds
            progressView.frame = CGRect(
                x: 0,
                y: navigationBarBounds.size.height - 2,
                width: navigationBarBounds.size.width,
                height: 2
            )
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
}
