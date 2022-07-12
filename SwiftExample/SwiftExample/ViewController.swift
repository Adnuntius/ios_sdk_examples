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
    private var labelAbove: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 100))
    private var adView: AdnuntiusAdWebView = AdnuntiusAdWebView(frame: CGRect(x: 0, y: 100, width: 320, height: 275))
    private var labelBelow: UILabel = UILabel(frame: CGRect(x: 0, y: 375, width: 320, height: 125))
    
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
        self.adView.scrollView.backgroundColor = .purple
        self.adView.isOpaque = false
        self.adView.scrollView.isOpaque = false
        self.view.addSubview(adView)
        
        self.view.backgroundColor = .blue
        self.view.setNeedsLayout()
        
        let defaults = UserDefaults.standard
        defaults.register(defaults:["globalUserId" : ""])
        
        let globalUserId = defaults.string(forKey: "globalUserId")!
        if globalUserId.isEmpty {
            print("No user id found, generating and saving a new one")
            defaults.set(UUID().uuidString, forKey: "globalUserId")
        }
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
        adView.enableDebug(true)
        
        let globalUserId = UserDefaults.standard.string(forKey: "globalUserId")!
        let sessionId = UUID().uuidString
        print("The global user id is \(globalUserId)")

        //adView.setEnv(AdnuntiusEnvironment.localhost)
        //let adRequest = AdRequest("00000000000001d9")
        
        let adRequest = AdRequest("000000000006f450")
        adRequest.keyValue("version", "6s")
        adRequest.height("10000")
        adRequest.width("10000")
        adRequest.sessionId(sessionId)
        adRequest.userId(globalUserId)
        //adRequest.livePreview("7pmy5r9rj62fyhjm", "60n8zsv29kx9mmty")
        adRequest.useCookies(false)
        
        let configStatus = adView.loadAd(adRequest, completionHandler: self, adnSdkHandler: self)
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
        print("Here is close")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
}
