//
//  ViewController.swift
//  Project4
//
//  Created by Vladimir on 09.12.2024.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    private(set) var websites = ["Apple", "HackingWithSwift", "Google"]
    private var leftArrow: UIBarButtonItem!
    private var rightArrow: UIBarButtonItem!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.\(websites[0].lowercased()).com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        title = "WebView"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
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

    @objc
    private func openTapped() {
        let ac = UIAlertController(title: "Open... page", message: nil, preferredStyle: .actionSheet)
        websites.forEach { website in
            ac.addAction(UIAlertAction(title: website, style: .default) {[weak self] aa in
                self?.handler(alert: aa)
            })
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    private func handler(alert: UIAlertAction?) {
        let url = URL(string: "https://www.\(alert?.title?.lowercased() ?? "").com")
        webView.load(URLRequest(url: url!))
        navigationItem.title = alert?.title
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

