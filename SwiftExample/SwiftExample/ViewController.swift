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
    private let globalUserId = UserDefaults.standard.string(forKey: "globalUserId")!
    private let sessionId = UUID().uuidString
    
    private var adView: AdnuntiusAdWebView = {
        let view = AdnuntiusAdWebView()
        view.logger.id = "adView"
        view.logger.debug = false
        view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        view.scrollView.isOpaque = false
        view.isOpaque = false
        return view
    }()
    
    private var adView2: AdnuntiusAdWebView = {
        let view = AdnuntiusAdWebView()
        view.logger.id = "adView2"
        view.logger.debug = false
        view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        view.scrollView.isOpaque = false
        view.isOpaque = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView: UIScrollView = {
            let view = UIScrollView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        scrollView.delegate = self
        
        let scrollStackViewContainer: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.spacing = 0
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let labelAbove: UILabel = {
            let label = UILabel()
            label.heightAnchor.constraint(equalToConstant: 125).isActive = true
            label.backgroundColor = UIColor.green
            label.text = "I'm above"
            return label
        }()
        
        let labelBetween: UILabel = {
            let label = UILabel()
            label.heightAnchor.constraint(equalToConstant: 250).isActive = true
            label.backgroundColor = UIColor.brown
            label.text = "I'm Between"
            return label
        }()
        
        let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollStackViewContainer.addArrangedSubview(labelAbove)
        scrollStackViewContainer.addArrangedSubview(adView)
        scrollStackViewContainer.addArrangedSubview(labelBetween)
        scrollStackViewContainer.addArrangedSubview(adView2)
        
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
            //var urlRequest: URLRequest = URLRequest(url: URL(string: "http://localhost:9999/observer.html")!)
            //self.adView.load(urlRequest)
            //var urlRequest2: URLRequest = URLRequest(url: URL(string: "http://localhost:9999/observer2.html")!)
            //self.adView2.load(urlRequest2)
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
        
        //print("The global user id is \(globalUserId)")

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
        
        adView.loadAd(adRequest, completionHandler: self, adnSdkHandler: self)
        
        let adRequest2 = AdRequest("000000000006f450")
        adRequest2.keyValue("version", "X")
        adRequest2.height("10000")
        adRequest2.width("10000")
        adRequest2.sessionId(sessionId)
        adRequest2.userId(globalUserId)
        //adRequest.livePreview("7pmy5r9rj62fyhjm", "60n8zsv29kx9mmty")
        adRequest2.useCookies(false)
        adView2.loadAd(adRequest2, completionHandler: self, adnSdkHandler: self)
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
        //print("onAdResponse \(view.logger.id): width: \(width), height: \(height)")
    }
    
    func onClose(_ view: AdnuntiusAdWebView) {
        print("Here is close")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
}
