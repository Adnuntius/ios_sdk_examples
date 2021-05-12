//
//  ViewController.swift
//  Example3
//
//  Copyright © 2019 Adnuntius. All rights reserved.
//

import WebKit
import AdnuntiusSDK

class ViewController: UIViewController, AdLoadCompletionHandler {
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
        // stupid apple, android studio has the ability to wait for the app to start before starting the debugger, pity
        // you can't do the same here apple!
        promptToLoadAd()

        //self.loadFromConfig()
    }
    
    private func loadFromConfig() {
        let configResult = adView.loadAd([
              "adUnits": [
                    ["auId": "000000000006f450", "auW": 200, "kv": [["version": "6s"]]
                ]
              ],
            "useCookies": false
            ], completionHandler: self)
        if !configResult {
            print("Config is wrong, check the log")
        }
    }
    
    func onNoAdResponse(_ view: AdnuntiusAdWebView) {
        print("No Ad Found!")
        self.adView.isHidden = true
    }
    
    func onFailure(_ view: AdnuntiusAdWebView, _ message: String) {
        view.loadHTMLString("<h1>Error is: \(message)</h1>",
        baseURL: nil)
    }
    
    func onAdResponse(_ view: AdnuntiusAdWebView, _ width: Int, _ height: Int) {
        print("onAdResponse: width: \(width), height: \(height)")
        var frame = self.adView.frame
        if (height > 0) {
            frame.size.height = CGFloat(height)
        }
        self.adView.frame = frame
    }
}
