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

        let adView1 = AdnuntiusAdWebView(frame: CGRect(x: 0, y: 10, width: self.tableView.frame.width, height: 200))
        let configCheck = adView1.loadFromApi([
               "adUnits": [
                ["auId": "000000000006f450", "kv": [["version": "6s"]]
                ]
            ]
            ], completionHandler: self)
        if !configCheck {
            print("What did you do, you broke the ad - check the logs")
        }
        adViews.append(adView1)
        
        let adView2 = AdnuntiusAdWebView(frame: CGRect(x: 0, y: 10, width: self.tableView.frame.width, height: 200))
        let config2Check = adView2.loadFromApi([
               "adUnits": [
                ["auId": "000000000006f450", "kv": [["version":"X"]]
                ]
            ]
            ], completionHandler: self)
        
        if !config2Check {
            print("What did you do, you broke the ad - check the logs")
        }
        adViews.append(adView2)
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
        
        /*webView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        webView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 10).isActive = true
        webView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true*/
        //webView.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
        //cell.heightAnchor.constraint(equalToConstant: webView.frame.height)
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
