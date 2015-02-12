//
//  MessageViewController.swift
//  e-MMU
//
//  Created by Parham Majdabadi on 07/02/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

class MessageViewController: JSQMessagesViewController {

    var conversationObject : PFObject?
    var timer : NSTimer!
    var isLoading = false
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(GRAY_COLOUR)
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(NAVIGATION_COLOUR)
    var messages : [JSQMessage] = []
    // We have to store avatars in dictionary for caching porpuses
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    var recipientUser : PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout.messageBubbleFont = BODY_FONT
        self.inputToolbar.contentView.leftBarButtonItem = nil
        self.inputToolbar.contentView.rightBarButtonItem.titleLabel?.font = HEADER_FONT
        self.inputToolbar.tintColor = NAVIGATION_COLOUR
        self.senderId = PFUser.currentUser().objectId
        
        // Create a timer to load messages in a particluar time with infinite loop
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "loadMessages", userInfo: nil, repeats: true)
        
        // If there is a history conversation between two users conversation object shouldn't be nil otherwise is nil
        if let object = self.conversationObject {
            // Check to see the recipient is user one or user two in conversation object
            if object[CONVERSATION_USER_ONE_KEY].objectId == PFUser.currentUser().objectId {
                self.recipientUser = object[CONVERSATION_USER_TWO_KEY] as PFUser
            } else {
                self.recipientUser = object[CONVERSATION_USER_ONE_KEY] as PFUser
            }

        }
        
        self.loadMessages()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    // MARK: - Helper methods
    func loadMessages() {
        // Make sure there is messages to load
        if let conObject = self.conversationObject {
            // Ignore this function if already is loading
            if self.isLoading == false {
                self.isLoading = true
                
                let lastMessage = self.messages.last
                
                // Query latest messages from conversation object
                let query = PFQuery(className: CONVERSATION_TEXT_KEY)
                query.whereKey(CONVERSATION_TEXT_CONVERSATION_ID_KEY, equalTo: conObject)
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
        
    }
    
    func createConversationObjectandSendText(text: String!) {
        self.conversationObject = PFObject(className: CONVERSATION_KEY)
        self.conversationObject?[CONVERSATION_IS_VALID_KEY] = true
        self.conversationObject?[CONVERSATION_USER_ONE_KEY] = PFUser.currentUser()
        self.conversationObject?[CONVERSATION_USER_TWO_KEY] = self.recipientUser
        
        let acl = PFACL()
        acl.setReadAccess(true, forUser: PFUser.currentUser())
        acl.setReadAccess(true, forUser: self.recipientUser)
        acl.setWriteAccess(true, forUser: PFUser.currentUser())
        acl.setWriteAccess(true, forUser: self.recipientUser)
        self.conversationObject?.ACL = acl
        
        self.conversationObject?.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
            if error == nil && success == true {
                self.sendText(self.conversationObject, text: text)
                
            } else {
                println(error)
            }
            
        })

    }
    
    func sendText(conversationObject: PFObject!, text: String!) {
        let object = PFObject(className: CONVERSATION_TEXT_KEY)
        object[CONVERSATION_TEXT_CONVERSATION_ID_KEY] = conversationObject
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
    
    // MARK: - JSQMessagesViewController method overrides
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        // Check to see if there is already a conversation object or we need to create one
        if let conObject = self.conversationObject {
            self.sendText(conObject, text: text)
        } else {
            self.createConversationObjectandSendText(text)
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
        } else {
            return self.incomingBubbleImageView
        }
    
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        var avatar = JSQMessagesAvatarImage(placeholder: UIImage(named: "profileImageHolder"))
        let message = self.messages[indexPath.item]
        // Check to see if there is already avatar cached
        if self.avatars[message.senderId] == nil {
            if message.senderId == PFUser.currentUser().objectId {
                let user = PFUser.currentUser()
                let images = user["pictures"] as? [PFFile]
                if let imagesUnwrapped = images {
                    imagesUnwrapped[0].getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            self.avatars[message.senderId] = JSQMessagesAvatarImage.avatarWithImage(UIImage(data: data))
                        }
                    })
                }
            } else {
                let user = self.recipientUser
                let images = user["pictures"] as? [PFFile]
                if let imagesUnwrapped = images {
                    imagesUnwrapped[0].getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            self.avatars[message.senderId] = JSQMessagesAvatarImage.avatarWithImage(UIImage(data: data))
                        }
                    })
                }
            }

        } else {
            avatar = self.avatars[message.senderId]
        }
        return avatar
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
        
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    // MARK: - UICollectionView DataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        let message = self.messages[indexPath.item]
        
        if message.senderId == PFUser.currentUser().objectId {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor, NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        
        return cell
        
    }
    
    // MARK: - JSQMessages collection view flow layout delegate
    // MARK: - Adjusting cell label heights
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = self.messages[indexPath.item]
        if message.senderId == PFUser.currentUser().objectId {
            return 0
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == PFUser.currentUser().objectId {
                return 0
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0
    }
}
