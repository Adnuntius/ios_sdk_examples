//
//  ViewController.swift
//  Example3
//
//  Copyright © 2019 Adnuntius. All rights reserved.
//

import WebKit
import AdnuntiusSDK

class ViewController: UIViewController, LoadAdHandler {
    @IBOutlet weak var adView: AdnuntiusAdWebView!
    
    fileprivate func promptToLoadAd() {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Do you want to release the Ads?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.loadFromConfig()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Declare Alert message this is just so we can attach the browser debugger
        promptToLoadAd()

        //self.loadFromConfig()
    }
    
    private func loadFromConfig() {
        adView.logger.debug = true
        
        let adRequest = AdRequest("000000000006f450")
        adRequest.keyValue("version", "6s")
        adView.loadAd(adRequest, self, delayViewEvents: false)
    }
    
    func onNoAdResponse(_ view: AdnuntiusAdWebView) {
        print("No Ad Found!")
        view.isHidden = true
    }
    
    func onFailure(_ view: AdnuntiusAdWebView, _ message: String) {
        view.loadHTMLString("<h1>Error is: \(message)</h1>", baseURL: nil)
    }
    
    func onAdResponse(_ view: AdnuntiusAdWebView, _ response: AdResponseInfo) {
        print("onAdResponse: width: \(response.definedWidth), height: \(response.definedHeight)")
        var frame = view.frame
        if (response.definedHeight > 0) {
            frame.size.height = CGFloat(response.definedHeight)
        }
        view.frame = frame
    }
}
