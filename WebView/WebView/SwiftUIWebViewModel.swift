//
//  SwiftUIWebViewModel.swift
//  WebView
//
//  Created by Jason Pell on 21/2/2023.
//

import Foundation
import WebKit

final class SwiftUIWebViewModel: NSObject, ObservableObject, WKScriptMessageHandler {
    @Published var urlString = ""
    
    let webView: WKWebView
    override init() {
        webView = WKWebView(frame: .zero)
        super.init()
        
        // this is some noop hooks to fool a customer website into doing their app mode
        webView.configuration.userContentController.add(self, name: "sizeNotification")
        webView.configuration.userContentController.add(self, name: "getFontSize")
        webView.configuration.userContentController.add(self, name: "setFontSize")
    }
    
    func loadUrl() {
        let theUrl = urlString.range(of: "^[a-z]+://", options:.regularExpression) != nil ? urlString : ("https://" + urlString)
        guard let url = URL(string: theUrl) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
