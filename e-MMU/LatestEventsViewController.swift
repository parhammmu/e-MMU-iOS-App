//
//  LatestEventsViewController.swift
//  e-MMU
//
//  Created by Parham on 23/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class LatestEventsViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var events: [RSSItem] = []
    var selectedUrl : NSURL?
    var images = Dictionary<String, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Activate the menu
        AppUtility.MenuNavigationSetup(self.menuButton, viewController: self, navigationController: navigationController)
        
        // Add loading to view
        AppUtility.showProgressViewForView(self.navigationController!.view, isDimmed: true)
        
        // Parsing the RSS feed
        self.parseFeed()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Check user state (user is logged in or not)
        AppUtility.checkUser(self)
        
        // Add pull to refresh
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.tableView.pullToRefreshView.arrowColor = MAIN_FONT_COLOUR
            self.tableView.pullToRefreshView.textColor = MAIN_FONT_COLOUR
            self.parseFeed()
            self.tableView.pullToRefreshView.stopAnimating()
        }

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
                                if categories[0] == "Events" {
                                    self.events.append(item)
                                }
                                
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                }
            } else {
                println(error)
            }
            // Hide loading view
            AppUtility.hideProgressViewFromView(self.navigationController!.view)
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.events[indexPath.row] as RSSItem
        self.selectedUrl = item.link
        self.performSegueWithIdentifier("LatestSegue", sender: self)
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as NewsTableViewCell
        
        if !self.events.isEmpty {
            let item = self.events[indexPath.row] as RSSItem
            cell.titleLabel.text = item.title
            
            if let description = item.itemDescription {
                // Stripe HTML tags
                let str = description.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                cell.excerptLabel.text = str
            }
            
            if !item.categories.isEmpty {
                let category = item.categories[0]
                // Check to see if the cell is new or has been loaded before, as most likely titles are unique
                if self.images[item.title!] == nil {
                    self.images[item.title!] = AppUtility.imageBasedOnCategory(category)
                    cell.imageView?.image = self.images[item.title!]
                } else {
                    cell.imageView?.image = self.images[item.title!]
                }
                
            }
            
            
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LatestSegue" {
            let ldvc = segue.destinationViewController as? LatestDetailViewController
            ldvc?.latestUrl = self.selectedUrl
        }
    }


}


