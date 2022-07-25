//
//  NewsTableViewController.swift
//  AdnuntiusTestApp
//
//

import WebKit
import AdnuntiusSDK

class NewsTableViewController: UITableViewController, LoadAdHandler {
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
        
        for i in 1 ... 3 {
            let adView = AdnuntiusAdWebView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 160))
            adView.logger.debug = true
            adView.logger.id = "adView\(i)"
            adView.scrollView.isScrollEnabled = false
            self.adViews.append(adView)
        }
        //promptToLoadAd()
        loadFromConfig()
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
        for i in 1 ... 3 {
            let adView = self.adViews[i - 1]
            let request = AdRequest("000000000006f450")
            if i % 3 == 0 {
                request.keyValue("version", "6s")
            } else if i % 2 == 0 {
                request.keyValue("version", "X")
            } else if i % 1 == 0 {
                request.keyValue("version", "unspecified")
            }
            adView.loadAd(request, self)
        }
    }
    
    func onAdResponse(_ view: AdnuntiusAdWebView, _ response: AdResponseInfo) {
        print("Ad Returned: height: \(response.definedHeight)")
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
            let idx = getAdIdx(idx: indexPath.row)
            if idx >= 0 {
                let adView = self.adViews[idx]
                return adView.frame.height
            }
        }
        return UITableView.automaticDimension
    }

    private func getAdIdx(idx: Int) -> Int {
        if idx == 0 {
            return 0
        } else if idx == 7 {
            return 1
        } else if idx == 14 {
            return 2
        } else {
            return -1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 7 == 0) {
            let idx = getAdIdx(idx: indexPath.row)
            if idx >= 0 {
                let adView = self.adViews[idx]
                let cell = UITableViewCell()
                cell.clipsToBounds = true
                cell.addSubview(adView)
                cell.sizeToFit()
                cell.layoutSubviews()
                return cell
            }
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row % 7 != 0) {
            tableView.deselectRow(at: indexPath, animated: true)
            let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
            tableView.beginUpdates()
            cell.descriptionLabel.numberOfLines = cell.descriptionLabel.numberOfLines == 4 ? 0 : 4
            cellStates?[indexPath.row] = cell.descriptionLabel.numberOfLines == 4 ? .collapsed : .expanded
            tableView.endUpdates()
        }
    }
}
