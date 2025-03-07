//
//  DetailViewController.swift
//  Project7
//
//  Created by Vladimir on 16.12.2024.
//

import UIKit
import WebKit


class DetailViewController: UIViewController {

    private var webView: WKWebView!
    var petition: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let petition else { return }
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(petition.body)
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }

}
