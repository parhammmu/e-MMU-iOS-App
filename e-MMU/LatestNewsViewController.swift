//
//  LatestNewsViewController.swift
//  e-MMU
//
//  Created by Parham on 23/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

private let refreshViewHeight: CGFloat = 200

class LatestNewsViewController: UITableViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    var news: [RSSItem] = []
    var refreshView : RefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshView = RefreshView(frame: CGRect(x: 0, y: -refreshViewHeight, width: CGRectGetWidth(view.bounds), height: refreshViewHeight), scrollView: tableView)
        self.refreshView.setTranslatesAutoresizingMaskIntoConstraints(false)
        refreshView.delegate = self
        view.insertSubview(refreshView, atIndex: 0)
        
        // Activate the menu
        AppUtility.MenuNavigationSetup(self.menuButton, viewController: self, navigationController: navigationController)
        
        // Parsing the RSS feed
        self.parseFeed()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Check user state (user is logged in or not)
        AppUtility.checkUser(self)
    }
    
    // MARK: - Helper methods
    
    func parseFeed() {
        let request = NSURLRequest(URL: NSURL(string: "http://diginnmmu.com/rss")!)
        RSSParser.parseFeedForRequest(request, callback: { (feed, error) -> Void in
            if error == nil {
                if let myFeed = feed? {
                    
                    for item: RSSItem in myFeed.items {
                        if let categories = item.categories {
                            if !categories.isEmpty {
                                if categories[0] != "Events" {
                                    self.news.append(item)
                                }
                                
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                    if self.refreshView.isRefreshing {
                        self.refreshView.endRefreshing()
                    }
                }
            } else {
                println(error)
            }
        })
    }
    
    // MARK: - ScrollView deletage
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.news.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as NewsTableViewCell

        if !self.news.isEmpty {
            let item = self.news[indexPath.row] as RSSItem
            cell.titleLabel.text = item.title
            cell.excerptLabel.text = item.itemDescription
            
            if !item.categories.isEmpty {
                let category = item.categories[0]
                cell.imageView?.image = AppUtility.imageBasedOnCategory(category)
            } else {
                
            }
            
    
        }

        return cell
    }

}

extension LatestNewsViewController: RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView) {
        self.parseFeed()
    }
}

