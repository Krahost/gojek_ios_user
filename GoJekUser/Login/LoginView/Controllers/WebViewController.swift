//
//  WebViewController.swift
//  GoJekUser
//
//  Created by Ansar on 02/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView : WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    var urlString: String = .empty
    var navTitle: String = .empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.load(request)
        }
        title = navTitle
        setLeftBarButtonWith(color: .blackColor)
        setNavigationTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        hideTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setWebViewFrame()
    }
    
    func setWebViewFrame() {
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//MARK:- WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
        LoadingIndicator.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        LoadingIndicator.hide()
    }
}

