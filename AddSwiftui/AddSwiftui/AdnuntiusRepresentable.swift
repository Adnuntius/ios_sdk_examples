//
//  AdnuntiusRepresentable.swift
//  AddSwiftui
//
//  Created by Alexander Larsen on 05/07/2022.
//

import AdnuntiusSDK
import Foundation
import SwiftUI

struct AdnuntiusRepresentable: UIViewRepresentable {
    private let adnuntiusAdWebView = AdnuntiusAdWebView()
    private var coordinator = AdnuntiusCoordinator()

    @Binding var width: CGFloat
    @Binding var height: CGFloat

    public var auId: String

    init(auId: String, width: Binding<CGFloat>, height: Binding<CGFloat>) {
        self.auId = auId
        _width = width
        _height = height
    }

    func makeUIView(context: Context) -> AdnuntiusAdWebView {
        adnuntiusAdWebView.enableDebug(true)
        adnuntiusAdWebView.loadAd(getRequest(), coordinator)
        return adnuntiusAdWebView
    }

    func updateUIView(_ uiView: AdnuntiusAdWebView, context: Context) {
    }

    func makeCoordinator() -> AdnuntiusCoordinator {
        coordinator.parent = self
        return coordinator
    }

    func getRequest() -> AdRequest {
        let adRequest = AdRequest(auId)
        adRequest.livePreview("p6zfczpgyjgyk71x", "2ftc67cfl1cbsdfl")
        adRequest.keyValue("version", "video")
        return adRequest
    }
}

class AdnuntiusCoordinator: NSObject, LoadAdHandler {
    var parent: AdnuntiusRepresentable?

    func onAdResponse(_ response: AdResponseInfo) {
        print("onAdResponse: \(response)")
        parent?.width = CGFloat(response.definedWidth)
        parent?.height = CGFloat(response.definedHeight+20)
    }
    
    func onAdResize(_ response: AdResponseInfo) {
        print("onAdResize: \(response)")
    }
}
