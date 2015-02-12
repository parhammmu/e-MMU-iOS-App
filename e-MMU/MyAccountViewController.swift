//
//  MyAccountViewController.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class MyAccountViewController: UITableViewController, UITextViewDelegate {
    
    var user : PFUser!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = PFUser.currentUser()
        println(self.user)
        
        // Delete cell separator
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        AppUtility.MenuNavigationSetup(self.menuButton, viewController: self, navigationController: navigationController)
    }
    
    // MARK: - Helper methods
    func settingUpTextViewCell(cell: UITableViewCell!, section: Int!) -> UITableViewCell {
        
        let textView = cell.viewWithTag(1) as? UITextView
        textView?.delegate = self
        switch section {
        case 0:
            // First name
            textView?.text = self.user[USER_FIRST_NAME_KEY] as? String
        case 1:
            // Last name
            textView?.text = self.user[USER_LAST_NAME_KEY] as? String
        case 2:
            // Age
            textView?.text = "\(self.user[USER_AGE_KEY])"
        case 3:
            // Student Number
            textView?.text = "\(self.user[USER_STUDENT_NUMBER])"
        default:
            return cell
        }
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 6 {
            return 200
        }
        return 70
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 60))
        view.backgroundColor = GRAY_COLOUR
        let label = UILabel(frame: CGRectMake(15, 20, self.tableView.frame.width - 30, 20))
        label.font = HEADER_FONT
        
        switch section {
        case 0:
            label.text = "First Name"
        case 1:
            label.text = "Last Name"
        case 2:
            label.text = "Age"
        case 3:
            label.text = "Student Number"
        case 4:
            label.text = "Faculty / Campus"
        case 5:
            label.text = "Push Notification"
        case 6:
            label.text = "Images"
        default:
            label.text = ""
        }
        
        view.addSubview(label)
        return view
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        switch indexPath.section {
        case 4:
            cell = tableView.dequeueReusableCellWithIdentifier("FacultyCell", forIndexPath: indexPath) as UITableViewCell
            return self.settingUpTextViewCell(cell, section: indexPath.section)
        case 5:
            cell = tableView.dequeueReusableCellWithIdentifier("PushCell", forIndexPath: indexPath) as UITableViewCell
            return self.settingUpTextViewCell(cell, section: indexPath.section)
        case 6:
            cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as UITableViewCell
            return self.settingUpTextViewCell(cell, section: indexPath.section)
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("TextViewCell", forIndexPath: indexPath) as UITableViewCell
            return self.settingUpTextViewCell(cell, section: indexPath.section)
        }

    }

}
