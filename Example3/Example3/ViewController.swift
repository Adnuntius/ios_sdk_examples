//
//  ViewController.swift
//  Example3
//
//  Copyright © 2019 Adnuntius. All rights reserved.
//

import UIKit
import AdnuntiusSDK

class ViewController: UIViewController, AdLoadCompletionHandler {
    @IBOutlet weak var adView: AdnuntiusAdWebView!

    fileprivate func promptToLoadScript() {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Do you want to release the Ads?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.loadFromScript()
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
        // promptToLoadScript()
        
        self.loadFromScript()
    }
    
    private func loadFromScript() {
        adView.loadFromScript("""
        <html>
        <script type="text/javascript" src="https://cdn.adnuntius.com/adn.js" async></script>
        <body>
        <div id="adn-000000000006f450" style="display:none"></div>
        <script type="text/javascript">
            window.adn = window.adn || {}; adn.calls = adn.calls || [];
              adn.calls.push(function() {
                adn.request({ adUnits: [
                    {auId: '000000000006f450', auW: 300, auH: 200, kv: [{'version':'X'}] }
                ]});
            });
        </script>   
        </body>
        </html>
        """, completionHandler: self)
    }
    
    func onComplete(_ view: AdnuntiusAdWebView, _ adCount: Int) {
        print("Completed: " + String(adCount))
    }
    
    func onFailure(_ view: AdnuntiusAdWebView, _ message: String) {
        view.loadHTMLString("<h1>Error is: " + message + "</h1>",
        baseURL: nil)
    }
}
