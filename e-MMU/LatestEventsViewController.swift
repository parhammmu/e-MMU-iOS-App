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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        })
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as EventTableViewCell

        if !self.events.isEmpty {
            let item = self.events[indexPath.row] as RSSItem
            cell.textLabel?.text = item.title
        }


        return cell
    }

}
