//
//  ViewController.swift
//  SwiftSample
//
//  Created by Adnuntius Australia on 7/12/20.
//

import AdnuntiusSDK
import WebKit
import UIKit

class ViewController: UIViewController, LoadAdHandler {
    private var scrollView: UIScrollView?
    
    private var adView: AdnuntiusAdWebView = {
        let view = AdnuntiusAdWebView()
        view.logger.id = "adView"
        view.logger.debug = true
        view.logger.verbose = false
        view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        view.scrollView.isOpaque = false
        view.scrollView.isScrollEnabled = false
        view.isOpaque = false
        return view
    }()

    private var adView2: AdnuntiusAdWebView = {
        let view = AdnuntiusAdWebView()
        view.logger.id = "adView2"
        view.logger.debug = true
        view.logger.verbose = false
        view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        view.scrollView.isOpaque = false
        view.scrollView.isScrollEnabled = false
        view.isOpaque = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView = {
            let view = UIScrollView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        self.scrollView!.delegate = self
        
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
        view.addSubview(self.scrollView!)
        self.scrollView!.addSubview(scrollStackViewContainer)
        self.scrollView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.scrollView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.scrollView!.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.scrollView!.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        scrollStackViewContainer.leadingAnchor.constraint(equalTo: self.scrollView!.leadingAnchor).isActive = true
        scrollStackViewContainer.trailingAnchor.constraint(equalTo: self.scrollView!.trailingAnchor).isActive = true
        scrollStackViewContainer.topAnchor.constraint(equalTo: self.scrollView!.topAnchor).isActive = true
        scrollStackViewContainer.bottomAnchor.constraint(equalTo: self.scrollView!.bottomAnchor).isActive = true
        scrollStackViewContainer.widthAnchor.constraint(equalTo: self.scrollView!.widthAnchor).isActive = true
        
        scrollStackViewContainer.addArrangedSubview(labelAbove)
        scrollStackViewContainer.addArrangedSubview(adView)
        scrollStackViewContainer.addArrangedSubview(labelBetween)
        scrollStackViewContainer.addArrangedSubview(adView2)
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
        let adRequest = AdRequest("000000000006f450")
        adRequest.keyValue("version", "6s")
        adRequest.useCookies(false)
        adView.loadAd(adRequest, self)
        
        let adRequest2 = AdRequest("000000000006f450")
        adRequest2.keyValue("version", "X")
        adRequest2.useCookies(false)
        adView2.loadAd(adRequest2, self)
    }
    
    func onAdResponse(_ view: AdnuntiusAdWebView, _ response: AdResponseInfo) {
        print("onAdResponse: \(response)")
    }
}
