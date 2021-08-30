//
//  ViewController.swift
//  SwiftSample
//
//  Created by Adnuntius Australia on 7/12/20.
//

import AdnuntiusSDK
import WebKit
import UIKit

class ViewController: UIViewController, AdLoadCompletionHandler, AdnSdkHandler {
    private var adView: AdnuntiusAdWebView = AdnuntiusAdWebView(frame: CGRect(x: 0, y: 100, width: 320, height: 275))
    private var labelAbove: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 100))
    private var labelBelow: UILabel = UILabel(frame: CGRect(x: 0, y: 375, width: 320, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelAbove.textAlignment = .center
        labelAbove.backgroundColor = .brown
        labelAbove.text = "I'm above"
        labelAbove.textColor = .white
        self.view.addSubview(labelAbove)
        
        labelBelow.textAlignment = .center
        labelBelow.backgroundColor = .green
        labelBelow.text = "I'm below"
        labelBelow.textColor = .white
        self.view.addSubview(labelBelow)

        self.adView.backgroundColor = .orange
        self.view.addSubview(adView)
        
        self.view.backgroundColor = .blue
        self.view.setNeedsLayout()
    }
    
    private func promptToLoadAd() {
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
        let config = [
            "adUnits": [
                   [
                    //"auId": "000000000006f450", "auW": 200, "kv": [["version": "3"]]
                    "auId": "000000000006f450"  , "kv": [["version": "interstitial2"]]
                   ]
            ],
            "useCookies": false//,
            //"lpl": "7pmy5r9rj62fyhjm",
            //"lpc": "60n8zsv29kx9mmty"
        ] as [String : Any]
        
        let configStatus = adView.loadAd(config, completionHandler: self, adnSdkHandler: self)
        if (!configStatus) {
            print("Check the logs, config is wrong")
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
    
    func onClose(_ view: AdnuntiusAdWebView) {
        Logger.debug("Here is close")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
}
