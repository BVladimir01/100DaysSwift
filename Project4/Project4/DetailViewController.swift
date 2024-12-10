//
//  DetailViewController.swift
//  Project4
//
//  Created by Vladimir on 10.12.2024.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    private var leftArrow: UIBarButtonItem!
    private var rightArrow: UIBarButtonItem!
    var website: String!
    var websites: [String]!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.\(website.lowercased()).com")
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        title = website
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        leftArrow = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBack))
        leftArrow.isEnabled = webView.canGoBack
        rightArrow = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: self, action: #selector(goForward))
        rightArrow.isEnabled = webView.canGoForward
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [leftArrow, spacer, rightArrow, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            progressView.progress = Float(webView.estimatedProgress)
        case "canGoBack":
            leftArrow.isEnabled = webView.canGoBack
        case "canGoForward":
            rightArrow.isEnabled = webView.canGoForward
        default:
            break
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let ac = UIAlertController(title: "Restricted website", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        let url = navigationAction.request.url
        if let host = url?.host() {
            for website in websites {
                if host.contains(website.lowercased()) {
                    decisionHandler(.allow)
                    return
                }
            }
            present(ac, animated: true)
        }
        decisionHandler(.cancel)
    }
    
    @objc
    private func goBack() {
        webView.goBack()
        if let host = webView.url?.host() {
            print(host)
            for website in websites {
                if host.contains(website.lowercased()) {
                    navigationItem.title = website
                }
            }
        }
    }
    
    @objc
    private func goForward() {
        webView.goForward()
        if let host = webView.url?.host() {
            for website in websites {
                if host.contains(website.lowercased()) {
                    navigationItem.title = website
                }
            }
        }
    }
}


