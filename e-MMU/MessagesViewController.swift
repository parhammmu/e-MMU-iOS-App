//
//  MessagesViewController.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var messages : [PFObject] = []
    var avators = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Activate the menu
        AppUtility.MenuNavigationSetup(self.menuButton, viewController: self, navigationController: navigationController)
        
        // Load messages
        self.loadMessages()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Check user state (user is logged in or not)
        AppUtility.checkUser(self)
        
        // Add pull to refresh
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.tableView.pullToRefreshView.arrowColor = MAIN_FONT_COLOUR
            self.tableView.pullToRefreshView.textColor = MAIN_FONT_COLOUR
            self.loadMessages()
            self.tableView.pullToRefreshView.stopAnimating()
        }
        
    }

    
    // MARK: - Helper methods
    
    func loadMessages() {
        
        AppUtility.showProgressViewForView(self.navigationController?.view, isDimmed: true)
        
        // Get messages when the user is sender
        let userOneQuery = PFQuery(className: CONVERSATION_KEY)
        userOneQuery.whereKey(CONVERSATION_USER_ONE_KEY, equalTo: PFUser.currentUser())
        userOneQuery.whereKey(CONVERSATION_IS_VALID_KEY, equalTo: true)
        
        // Get messages when the user is receiver
        let userTwoQuery = PFQuery(className: CONVERSATION_KEY)
        userTwoQuery.whereKey(CONVERSATION_USER_TWO_KEY, equalTo: PFUser.currentUser())
        userTwoQuery.whereKey(CONVERSATION_IS_VALID_KEY, equalTo: true)
        
        // Compund query
        let query = PFQuery.orQueryWithSubqueries([userOneQuery, userTwoQuery])
        query.orderByDescending(UPDATED_AT_KEY)
        query.limit = 50
        query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]!, error : NSError!) -> Void in
            
            if error == nil {
                
                if let messages = objects as? [PFObject] {
                    self.messages = messages
                    self.tableView.reloadData()
                }
                
            } else {
                println(error)
            }
            
            AppUtility.hideProgressViewFromView(self.navigationController?.view)
        }

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as MessageTableViewCell

        // Configure the cell...

        return cell
    }

}
