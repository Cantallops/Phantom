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
    private var progressViewObserver: Any?

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

        progressViewObserver = webView.observe(\.estimatedProgress) { [weak self] webView, _ in
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }

    func load(url: URL) {
        self.url = url
    }

    private func setUpProgressBar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .clear
        progressView.progressTintColor = Color.tint
        progressView.progress = 0
        progressView.isHidden = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.leftAnchor.constraint(equalTo: view.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: view.rightAnchor),
            progressView.topAnchor.constraint(equalTo: view.topAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
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
