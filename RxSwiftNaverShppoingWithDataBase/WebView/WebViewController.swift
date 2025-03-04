//
//  WebViewController.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/4/25.
//

import UIKit

import WebKit
import SnapKit

final class WebViewController: UIViewController {

    private let web = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.startAnimating()
        layout()
        loadWebPage(url)
        web.navigationDelegate = self
    }
    
    private func loadWebPage(_ url: String) {
        
        var components = URLComponents(string: url)!
        components.host! = "m." + components.host!        
        
        let URLToRequest = URLRequest(url: components.url!)
        web.load(URLToRequest)
        
    }
    
    private func layout() {
        view.addSubview(web)
        view.addSubview(activityIndicator)
        
        web.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }



}

extension WebViewController: WKNavigationDelegate {
    // 로딩 중
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    //로딩 완료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    //로딩 실패
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
