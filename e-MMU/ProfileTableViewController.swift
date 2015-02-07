//
//  ProfileTableViewController.swift
//  e-MMU
//
//  Created by Parham Majdabadi on 05/02/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, UIPageViewControllerDataSource {

    var user : PFUser!
    var pageController : UIPageViewController!
    var numberOfPictures = 0
    var conversationObject : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        // remove cell seprator
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Get the number of pictures available for given user
        if let pictures = self.user["pictures"] as? [PFFile] {
            self.numberOfPictures = pictures.count
        }
        
        // Get refrence tp page view using stoaryboard id
        self.pageController = self.storyboard!.instantiateViewControllerWithIdentifier("SliderPageViewController") as UIPageViewController
        self.pageController.dataSource = self
        
        let svc = self.viewControllerAtIndex(0)
        let viewControllers = [svc!]
        self.pageController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        // Change the size of page view controller
        self.pageController.view.frame = CGRectMake(0, 0, self.tableView.frame.width, self.tableView.frame.width - 20);
        
        self.addChildViewController(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMoveToParentViewController(self)

    }
    
    // MARK: - Helper methods
    
    func viewControllerAtIndex(index: Int) -> SliderViewController? {
        if self.numberOfPictures == 0 || index >= self.numberOfPictures {
            return nil
        }
        
        // Create a new view controller and pass suitable data
        let svc = self.storyboard?.instantiateViewControllerWithIdentifier("SliderViewController") as SliderViewController
        svc.pageIndex = index
        
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRectMake(self.tableView.frame.width/2, self.tableView.frame.width/2, 30, 30)
        
        svc.view.addSubview(indicator)
        
        //let imageUrl = self.user.images[index].url as String
        
        if let pictures = self.user[USER_PICTURES_KEY] as? [PFFile] {
            
            pictures[index].getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                if error == nil {
                    svc.slideImageView.image = UIImage(data: data)
                } else {
                    println(error)
                }
            })
        }
        return svc
    }
    
    func cellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell! {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as ProfileSliderTableViewCell
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath) as ProfileNameTableViewCell
            
            // Set name
            var fullName = ""
            if let firstName = self.user[USER_FIRST_NAME_KEY] as? String {
                fullName += firstName
            }
            if let lastName = self.user[USER_LAST_NAME_KEY] as? String {
                fullName = fullName + " " + lastName
            }
            cell.nameLabel.text = fullName
            
            // Set gender image
            if let sex = self.user[USER_GENDER_KEY] as? String {
                if sex == Sex.Female.rawValue {
                    cell.imageView?.image = UIImage(named: "women-icon")
                } else {
                    cell.imageView?.image = UIImage(named: "man-icon")
                }
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("AgeCell", forIndexPath: indexPath) as ProfileAgeTableViewCell
            if let age = self.user[USER_AGE_KEY] as? Int {
                cell.ageLabel.text = "\(age)"
            } else {
                cell.ageLabel.text = "N/A"
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("AboutCell", forIndexPath: indexPath) as ProfileAboutTableViewCell
            if let about = self.user[USER_About_KEY] as? String {
                cell.aboutLabel.text = about
            } else {
                cell.aboutLabel.text = "No Text to display!"
            }
            return cell
        }
        
        
    }
    
    // Send message tapped, perfroming the sugue
    func sendMessageTapped() {
        
        //Check to see if there is already a conversation between these two users
        let firstQuery = PFQuery(className: CONVERSATION_KEY)
        firstQuery.whereKey(CONVERSATION_USER_ONE_KEY, equalTo: self.user)
        firstQuery.whereKey(CONVERSATION_USER_TWO_KEY, equalTo: PFUser.currentUser())
        firstQuery.whereKey(CONVERSATION_IS_VALID_KEY, equalTo: true)
        
        let secondQuery = PFQuery(className: CONVERSATION_KEY)
        secondQuery.whereKey(CONVERSATION_USER_ONE_KEY, equalTo: PFUser.currentUser())
        secondQuery.whereKey(CONVERSATION_USER_TWO_KEY, equalTo: self.user)
        secondQuery.whereKey(CONVERSATION_IS_VALID_KEY, equalTo: true)
        
        let compoundQuery = PFQuery.orQueryWithSubqueries([firstQuery, secondQuery])
        compoundQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                self.conversationObject = object
            } else {
                println(error)
            }
            
            self.performSegueWithIdentifier("SendMessageSegue", sender: self)
            
        }
    }
    
    // MARK: - PageViewController data source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let svc = viewController as SliderViewController
        
        var index = svc.pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let svc = viewController as SliderViewController
        
        var index = svc.pageIndex
        
        if index == NSNotFound {
            return nil
        }
        index++
        
        if index == self.numberOfPictures {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.numberOfPictures
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 60
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 60))
        view.backgroundColor = GRAY_COLOUR
        let label = UILabel(frame: CGRectMake(15, 20, self.tableView.frame.width - 30, 20))
        label.font = HEADER_FONT
        
        switch section {
        case 1:
            label.text = "Name"
        case 2:
            label.text = "Age"
        case 3:
            label.text = "About"
        default:
            label.text = ""
        }
        
        // If the header is slider header return nil otherwise return appropriate view
        if section > 0 {
            view.addSubview(label)
            return view
        } else {
            return nil
        }
        

    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 50
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        // Create send message button
        if section == 3 {
            let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 50))
            footerView.backgroundColor = BUTTON_COLOUR
            let sendMessage = UIButton(frame: CGRectMake(0, 0, tableView.frame.width, 50))
            sendMessage.addTarget(self, action: Selector("sendMessageTapped"), forControlEvents: UIControlEvents.TouchUpInside)
            sendMessage.titleLabel?.textAlignment = NSTextAlignment.Center
            
            if let firstName = self.user[USER_FIRST_NAME_KEY] as? String {
                sendMessage.setTitle("Send \(firstName) Message", forState: UIControlState.Normal)
            } else {
                sendMessage.setTitle("Send Message", forState: UIControlState.Normal)
            }

            footerView.addSubview(sendMessage)
            return footerView
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath {
        case 0:
            return 300
        case 3:
            return 200
        default:
            return 105
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return self.cellForIndexPath(indexPath)
    }
    
    // MARK: - Action methods
    @IBAction func reportButtonTapped(sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Segue Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sendMessageSegue" {
            // Check to see if convesation object is not nil
            if let object = self.conversationObject {
                let mvc = segue.destinationViewController as? MessageViewController
                mvc?.conversationObject = object
            }
            
        }
    }

}
