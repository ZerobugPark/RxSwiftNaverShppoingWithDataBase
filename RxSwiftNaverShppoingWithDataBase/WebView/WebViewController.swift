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
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(url)
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
        
        web.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }



}

extension WebViewController: WKNavigationDelegate {
    
}
