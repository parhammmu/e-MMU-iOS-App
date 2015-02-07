//
//  MessageViewController.swift
//  e-MMU
//
//  Created by Parham Majdabadi on 07/02/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

class MessageViewController: JSQMessagesViewController {

    var conversationObject : PFObject!
    var timer : NSTimer!
    var isLoading = false
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(GRAY_COLOUR)
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(NAVIGATION_COLOUR)
    var messages : [JSQMessage] = []
    var avatars = Dictionary<String, UIImage>()
    var recipientUser : PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout.messageBubbleFont = BODY_FONT
        self.inputToolbar.contentView.leftBarButtonItem = nil
        self.inputToolbar.contentView.rightBarButtonItem.titleLabel?.font = HEADER_FONT
        self.inputToolbar.tintColor = NAVIGATION_COLOUR
        
        // Create a timer to load messages in a particluar time with infinite loop
        self.timer = NSTimer(timeInterval: 5.0, target: self, selector: Selector(loadMessages()), userInfo: nil, repeats: true)
        
        // Check to see the recipient is user one or user two in conversation object
        if self.conversationObject[CONVERSATION_USER_ONE_KEY].objectId == PFUser.currentUser().objectId {
            self.recipientUser = self.conversationObject[CONVERSATION_USER_TWO_KEY] as? PFUser
        } else {
            self.recipientUser = self.conversationObject[CONVERSATION_USER_ONE_KEY] as? PFUser
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    // MARK: - Helper methods
    func loadMessages() {
        
        // Ignore this function if already is loading
        if self.isLoading == false {
            self.isLoading = true
            
            let lastMessage = self.messages.last
            
            // Query latest messages from conversation object
            let query = PFQuery(className: CONVERSATION_TEXT_KEY)
            query.whereKey(CONVERSATION_TEXT_CONVERSATION_ID_KEY, equalTo: self.conversationObject)
            if lastMessage != nil {
                query.whereKey(CREATED_AT_KEY, greaterThan: lastMessage?.date)
            }
            query.includeKey(CONVERSATION_TEXT_BELONG_TO_KEY)
            query.orderByAscending(CREATED_AT_KEY)
            query.findObjectsInBackgroundWithBlock({ (result: [AnyObject]!, error: NSError!) -> Void in
                
                if error == nil {
                    
                    if let objects = result as? [PFObject] {
                        for object in objects {
                            if let text = object[CONVERSATION_TEXT_TEXT_KEY] as? String {
                                let message = JSQMessage(senderId: object[CONVERSATION_TEXT_BELONG_TO_KEY].objectId, senderDisplayName: object[CONVERSATION_TEXT_BELONG_TO_KEY].objectId, date: object.createdAt, text: text)
                                self.messages.append(message)
                            }
                            
                        }
                        self.finishReceivingMessage()
                    }
                    
                    
                } else {
                    println(error)
                }
                self.isLoading = false
                
            })
            
        }
        
    }
    
    // MARK: - JSQMessagesViewController method overrides
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let object = PFObject(className: CONVERSATION_TEXT_KEY)
        object[CONVERSATION_TEXT_CONVERSATION_ID_KEY] = self.conversationObject
        object[CONVERSATION_TEXT_BELONG_TO_KEY] = PFUser.currentUser()
        object[CONVERSATION_TEXT_TEXT_KEY] = text
        
        // Set ACL
        let acl = PFACL()
        acl.setReadAccess(true, forUser: PFUser.currentUser())
        acl.setReadAccess(true, forUser: self.recipientUser)
        acl.setWriteAccess(true, forUser: PFUser.currentUser())
        object.ACL = acl
        
        object.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error == nil && succeeded == true {
                
                // Play send audio
                JSQSystemSoundPlayer.jsq_playMessageSentAlert()
                self.loadMessages()
                
            } else {
                println(error)
            }
            self.finishSendingMessageAnimated(true)
        }
        
        
    }
    
    // MARK: - JSQMessages CollectionView DataSource
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.item]
        if message.senderId == PFUser.currentUser().objectId {
            return self.outgoingBubbleImageView
        }
        return self.incomingBubbleImageView
    
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        // Show a timestamp for every 3rd message
        if indexPath.item % 3 == 0 {
            let message = self.messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        // TODO
        return nil
    }
}
