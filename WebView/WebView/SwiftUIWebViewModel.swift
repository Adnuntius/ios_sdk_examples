//
//  SwiftUIWebViewModel.swift
//  WebView
//
//  Created by Jason Pell on 21/2/2023.
//

import Foundation
import WebKit

final class SwiftUIWebViewModel: NSObject, ObservableObject, WKScriptMessageHandler {
    @Published var urlString = "https://github.com/Adnuntius"
    
    let webView: WKWebView
    override init() {
        webView = WKWebView(frame: .zero)
        super.init()
        webView.configuration.userContentController.add(self, name: "sizeNotification")
        webView.configuration.userContentController.add(self, name: "getFontSize")
        webView.configuration.userContentController.add(self, name: "setFontSize")
    }
    
    func loadUrl() {
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
