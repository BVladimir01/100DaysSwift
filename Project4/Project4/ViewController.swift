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
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        title = "WebView"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }

    @objc
    private func openTapped() {
        let ac = UIAlertController(title: "Open... page", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Apple", style: .default, handler: handler))
        ac.addAction(UIAlertAction(title: "HackingWithSwift", style: .default, handler: handler))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    private func handler(alert: UIAlertAction) {
        let url = URL(string: "https://www." + (alert.title?.lowercased() ?? "") + ".com")
        webView.load(URLRequest(url: url!))
        navigationItem.title = alert.title
    }
}

