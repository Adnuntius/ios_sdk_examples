//
//  ContentView.swift
//  WebView
//
//  Created by Jason Pell on 21/2/2023.
//

import SwiftUI
import WebKit

// https://medium.com/devtechie/webview-in-swiftui-a9c283f29327
struct ContentView: View {
    @StateObject private var model = SwiftUIWebViewModel()

    var body: some View {
        VStack {
            SwiftUIWebView(webView: model.webView)
        }
        HStack {
            TextField("Enter url", text: $model.urlString)
                                .textFieldStyle(.roundedBorder)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
            Button("Go") {
                model.loadUrl()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SwiftUIWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
