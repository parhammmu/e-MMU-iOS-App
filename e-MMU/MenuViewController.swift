//
//  MenuViewController.swift
//  e-MMU
//
//  Created by Parham on 23/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = MENU_BG
        tableView.separatorColor = MENU_BORDER_COLOUR

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0 || section == 3 {
            return 1
        }
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 250
        }
        return 60
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        var header = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 40))
        var label = UILabel(frame: CGRectMake(30, 0, self.tableView.frame.width - 60, 40))
        label.textColor = MENU_FONT_BODY_COLOUR
        label.font = MENU_HEADER_FONT
        
        switch section {
            case 1:
            label.text = "Latest"
            case 2:
            label.text = "Social"
            case 3:
            label.text = "Registration"
            case 4:
            label.text = "Account"
            default:
            label.text = ""
        }
        header.addSubview(label)
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath.section) {
        case 1:
            
            if indexPath.row == 0 {
                self.performSegueWithIdentifier("MMUNews", sender: self)
            } else {
                self.performSegueWithIdentifier("MMUEvents", sender: self)
            }
            
        case 2:
            
            if indexPath.row == 0 {
                //menuText?.text = "FIND FRIENDS"
            } else {
                //menuText?.text = "MESSAGES"
            }
            
        case 3:
            
            self.performSegueWithIdentifier("MMUNews", sender: self)
            
        case 4:
            
            if indexPath.row == 0 {
                //menuText?.text = "MY ACCOUNT"
            } else {
                //menuText?.text = "SIGN OUT"
            }
            
            
        default:
            self.performSegueWithIdentifier("MMUNews", sender: self)
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row == 0 && indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath) as UITableViewCell
            let name = self.tableView.viewWithTag(3) as? UILabel
            name?.textColor = UIColor.whiteColor()
            name?.font = MENU_NAME_FONT
            name?.text = "Parham Majdabadi"
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            let menuText = self.tableView.viewWithTag(1) as? UILabel
            menuText?.textColor = MENU_FONT_BODY_COLOUR
            menuText?.font = MENU_BODY_FONT
            
            switch (indexPath.section) {
                case 1:
                
                    if indexPath.row == 0 {
                        menuText?.text = "MMU NEWS"
                    } else {
                        menuText?.text = "MMU EVENTS"
                    }
                
                case 2:
                
                    if indexPath.row == 0 {
                        menuText?.text = "FIND FRIENDS"
                    } else {
                        menuText?.text = "MESSAGES"
                    }

                case 3:
                    
                    menuText?.text = "ONLINE REGISTRAITION"
                
                case 4:
                
                    if indexPath.row == 0 {
                        menuText?.text = "MY ACCOUNT"
                    } else {
                        menuText?.text = "SIGN OUT"
                    }
                
                
            default:
                cell.textLabel?.text = ""
            }
        }
        
        cell.backgroundColor = MENU_BG

        return cell
    }

}
