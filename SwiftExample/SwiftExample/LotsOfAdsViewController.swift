//
//  ViewController.swift
//  SwiftSample
//
//  Created by Adnuntius Australia on 7/12/20.
//

import AdnuntiusSDK
import WebKit
import UIKit

private class Creative {
    public let lineItemId: String
    public let creativeId: String
    
    public init(_ lineItemId: String, _ creativeId: String) {
        self.lineItemId = lineItemId
        self.creativeId = creativeId
    }
}

class LotsOfAdsViewController: UIViewController, LoadAdHandler {
    private var creativeIdx: Int = -1
    
    private var creatives:[Creative] = [
        //Creative("d8qb07frnnzktdlp", "07fl69n2b8wbpn37"),
        Creative("qf8b99yd629xkkt1", "21cq2rb9yfptpkpm"),
//        Creative("51bnxdp98ckxzs3g", "8w1595rly1963yzd"),
//        Creative("0p8rgrljkqhdtp3z", "rhwjnrv6ljrkn035"),
//        Creative("qlj7f2zh2cwvq1qr", "p6qpcq7sq67m6mzf"),
//        Creative("9t7ttd11cpjxg2p5", "bclqbzdw6nmxtm2p"),
//        Creative("rx6zqxb2d08dkc9f", "711fh0nm5lt5w3xg"),
//        Creative("bcp13x1v8svddv99", "3v3dc10m2bg30ys7"),
//        Creative("51bnxdp98ckxzs3g", "311xxr0mwm75dss6"),
//        Creative("qf8b99yd629xkkt1", "z539bknqnplvzyjl"),
//        Creative("ckwckqdvp1cw5k91", "3fs90nvsqy6702fb"),
//        Creative("0zzfskwvd5qf901n", "y69d11l5k3x7t3f3"),
//        Creative("d56fd5rhfjtdpl5w", "h7ss1yt0ccjjwhnr"),
//        Creative("p6zfczpgyjgyk71x", "2ftc67cfl1cbsdfl"),
//        Creative("6nyms9086dlrgnp5", "l1l08kzbpwvhlcxk"),
//        Creative("5bpdzvmhflx78p67", "1bcpcpphkb0rdx59"),
//        Creative("jsftlb3jrx8hx2yl", "nw9z2mgs2yl9sqt7"),
//        Creative("q8rntjmc6bxzzfdk", "z8rjcyy0bhy9357x"),
//        Creative("y8r0drznv7t0cwf3", "8tgz0lsgdyvyjd50"),
//        Creative("pb1d2362y3nw9wm6", "l1l7vz96fdxzdsbm"),
//        Creative("f5hkh0m876zxlshw", "wysy25l7zx5vbv2d"),
//        Creative("dvv789cdf5tjggrh", "9kwdysnztt7hrzbb")
    ]
    
    private var labelAbove: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    private var adView: AdnuntiusAdWebView = AdnuntiusAdWebView(frame: CGRect(x: 0, y: 50, width: 320, height: 275))
    private var labelBelow: UILabel = UILabel(frame: CGRect(x: 0, y: 325, width: 320, height: 125))

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
    
    private func confirmAd(_ response: AdResponseInfo) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Is \(response.lineItemId): \(response.creativeId) OK?", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.loadNewAd()
        })
    
        dialogMessage.addAction(ok)
        DispatchQueue.main.async {
            self.present(dialogMessage, animated: true, completion: {
                dialogMessage.view.frame.origin.y = 0
            })
        }
    }
    
    private func loadNewAd() {
        self.creativeIdx+=1
        if self.creativeIdx < self.creatives.count {
            let creative = self.creatives[creativeIdx]
            let adRequest = AdRequest("00000000000b42ef")
            adRequest.livePreview(creative.lineItemId, creative.creativeId)
            adView.loadAd(adRequest, self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        adView.enableDebug(true)
        loadNewAd()
    }
    
    func onNoAdResponse() {
        print("No Ad Found!")
        self.adView.isHidden = true
    }
    
    func onFailure(_ message: String) {
        DispatchQueue.main.async {
            self.adView.loadHTMLString("<h1>Error is: \(message)</h1>", baseURL: nil)
        }
    }

    func onAdResize(_ response: AdResponseInfo) {
        print("onAdResize: \(response)")
    }
    
    func onAdResponse(_ response: AdResponseInfo) {
        print("onAdResponse: \(response)")
        
        var frame = self.adView.frame
        if (response.definedHeight > 0) {
            frame.size.height = CGFloat(response.definedHeight + 1)
        }
        self.adView.frame = frame
        confirmAd(response)
    }
    
    func onLayoutCloseView() {
        print("Here is close")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
}

