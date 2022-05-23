//
//  NewsTableViewController.swift
//  AdnuntiusTestApp
//
//

import WebKit
import AdnuntiusSDK

class NewsTableViewController: UITableViewController, AdLoadCompletionHandler {
    
    
    fileprivate let feedParser = FeedParser()
    fileprivate let feedURL = "http://www.apple.com/main/rss/hotnews/hotnews.rss"

    fileprivate var rssItems: [(title: String, description: String, pubDate: String)]?
    fileprivate var cellStates: [CellState]?
    fileprivate var adView1: AdnuntiusAdWebView?
    fileprivate var adView2: AdnuntiusAdWebView?
    fileprivate var adRequest1: AdRequest?
    fileprivate var adRequest2: AdRequest?
    fileprivate var adViews: [AdnuntiusAdWebView] = [AdnuntiusAdWebView]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension

        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

        feedParser.parseFeed(feedURL: feedURL) { [weak self] rssItems in
            self?.rssItems = rssItems
            self?.cellStates = Array(repeating: .collapsed, count: rssItems.count)

            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }

        adView1 = AdnuntiusAdWebView(frame: CGRect(x: 0, y: 10, width: self.tableView.frame.width, height: 200))
        adView1!.enableDebug(true)
        adRequest1 = AdRequest("00000000000432e3")
        adRequest1!.keyValue("isolate", "ipl-app-test")
        adRequest1!.width("10000")
        adRequest1!.height("10000")
        adViews.append(adView1!)
        
        adView2 = AdnuntiusAdWebView(frame: CGRect(x: 0, y: 10, width: self.tableView.frame.width, height: 200))
        adView2!.enableDebug(true)
        adRequest2 = AdRequest("00000000000432e3")
        adRequest2!.keyValue("isolate", "ipl-app-test")
        adRequest2!.width("10000")
        adRequest2!.height("10000")
        adViews.append(adView2!)
        
        // Declare Alert message this is just so we can attach the browser debugger
        promptToLoadAd()
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

    private func loadFromConfig() {
        let configCheck = adView1!.loadAd(adRequest1!, completionHandler: self)
        if !configCheck {
            print("What did you do, you broke the ad - check the logs")
        }
        let config2Check = adView2!.loadAd(adRequest2!, completionHandler: self)
        if !config2Check {
            print("What did you do, you broke the ad - check the logs")
        }
    }
    
    func onNoAdResponse(_ view: AdnuntiusAdWebView) {
        print("No ad returned")
    }
    
    func onAdResponse(_ view: AdnuntiusAdWebView, _ width: Int, _ height: Int) {
        print("Ad Returned: height: \(height)")
        if height > 0 {
            var frame = view.frame
            frame.size.height = CGFloat(height)
            view.frame = frame
        }
    }

    func onFailure(_ view: AdnuntiusAdWebView, _ message: String) {
        print("Failure: \(message)")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
          return 0
        }
        return rssItems.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row % 7 == 0) {
            //print(self.adViews[0].frame.height)
            return self.adViews[indexPath.row % 2 == 0 ? 0 : 1].frame.height
        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Adnuntius injector
    if (indexPath.row % 7 == 0) {
        let cell = UITableViewCell()
        let webView = self.adViews[indexPath.row % 2 == 0 ? 0 : 1]
        webView.scrollView.isScrollEnabled = false
        
        cell.clipsToBounds = true
        cell.addSubview(webView)
        cell.sizeToFit()
        cell.layoutSubviews()

        return cell
    }

    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell

    if let item = rssItems?[indexPath.row] {
        (cell.titleLabel.text, cell.descriptionLabel.text, cell.dateLabel.text) = (item.title, item.description, item.pubDate)

        if let cellState = cellStates?[indexPath.row] {
            cell.descriptionLabel.numberOfLines = cellState == .expanded ? 0: 4
        }
    }

return cell
}

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell

        tableView.beginUpdates()
        cell.descriptionLabel.numberOfLines = cell.descriptionLabel.numberOfLines == 4 ? 0 : 4
        cellStates?[indexPath.row] = cell.descriptionLabel.numberOfLines == 4 ? .collapsed : .expanded
        tableView.endUpdates()
    }
}
