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
    var selectedMessage : PFObject!
    var avators = Dictionary<String, UIImage>()
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = self.messages[indexPath.row]
        self.selectedMessage = message
        self.performSegueWithIdentifier("MessageSegue", sender: self)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as MessageTableViewCell

        if !self.messages.isEmpty {
            let message = self.messages[indexPath.row]
            
            let userOne = message[CONVERSATION_USER_ONE_KEY] as PFObject
            
            userOne.fetchInBackgroundWithBlock({ (objectOne: PFObject!, error: NSError!) -> Void in
                if error == nil {
                    let userTwo = message[CONVERSATION_USER_TWO_KEY] as PFObject
                    userTwo.fetchInBackgroundWithBlock({ (objectTwo: PFObject!, error: NSError!) -> Void in
                        if error == nil {
                            // User one is current user so we need to get user two info
                            if userOne.objectId == PFUser.currentUser().objectId {
                                cell.nameLabel.text = objectTwo[USER_FIRST_NAME_KEY] as? String
                                
                                // Check if we have cached the image in avatars dictionary
                                if self.avators[objectTwo.objectId] == nil {
                                    let pictures = objectTwo[USER_PICTURES_KEY] as [PFFile]
                                    if !pictures.isEmpty {
                                        let picture = pictures[0]
                                        picture.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                                            if error == nil {
                                                self.avators[objectTwo.objectId] = UIImage(data: data)
                                                cell.profileImageView.image = self.avators[objectTwo.objectId]
                                            }
                                        })
                                    }

                                } else {
                                    cell.profileImageView.image = self.avators[objectTwo.objectId]
                                }
                                
                            } else {
                                // User two is current user so we need to get user one info
                                cell.nameLabel.text = objectOne[USER_FIRST_NAME_KEY] as? String
                                
                                // Check if we have cached the image in avatars dictionary
                                if self.avators[objectOne.objectId] == nil {
                                    let pictures = objectOne[USER_PICTURES_KEY] as [PFFile]
                                    if !pictures.isEmpty {
                                        let picture = pictures[0]
                                        picture.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                                            if error == nil {
                                                self.avators[objectOne.objectId] = UIImage(data: data)
                                                cell.profileImageView.image = self.avators[objectOne.objectId]
                                            }
                                        })
                                    }
                                } else {
                                    cell.profileImageView.image = self.avators[objectOne.objectId]
                                }
                                
                            }
                        }
                    })
                }
            })
        }
        
        return cell
    }
    
    // MARK: - Segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MessageSegue" {
            let mvc = segue.destinationViewController as MessageViewController
            mvc.conversationObject = self.selectedMessage
        }
    }
    
}
