//
//  FindFriendsViewController.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class FindFriendsViewController: UITableViewController, FilterDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var students : [PFObject] = []
    var selectedStudent : PFObject? = nil
    var filteredAgeFrom : Int? = nil
    var filteredAgeTo : Int? = nil
    var filteredSex : Sex? = nil
    var filteredFaculty : Faculty? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Activate the menu
        AppUtility.MenuNavigationSetup(self.menuButton, viewController: self, navigationController: navigationController)
        
        AppUtility.showProgressViewForView(self.navigationController?.view, isDimmed: true)
        
        self.loadStudents(nil, toAge: nil, sex: nil, faculty: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Check user state (user is logged in or not)
        AppUtility.checkUser(self)
        
        let installation = PFInstallation.currentInstallation()
        // if user has accepted the push notification
        if installation["appName"] as? String == "e-MMU" {
            installation["user"] = PFUser.currentUser()
            installation.saveEventually()
        }
        
        // Check to see if we have the age of user otherwise show alert view
        if PFUser.currentUser()[USER_AGE_KEY] == nil {
            AppUtility.showAgeAlerView(self)
        }
        
        // Add pull to refresh
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.tableView.pullToRefreshView.arrowColor = MAIN_FONT_COLOUR
            self.tableView.pullToRefreshView.textColor = MAIN_FONT_COLOUR
            self.loadStudents(self.filteredAgeFrom, toAge: self.filteredAgeTo, sex: self.filteredSex, faculty: self.filteredFaculty)
            self.tableView.pullToRefreshView.stopAnimating()
        }
        
    }

    
    // MARK: - Helper methods
    
    func loadStudents(fromAge: Int?, toAge: Int?, sex: Sex?, faculty: Faculty?) {
        
        let query = PFUser.query()
        // exclude the current user
        query.whereKey(OBJECT_ID_KEY, notEqualTo: PFUser.currentUser().objectId)
        
        // Check to make sure the user is not in current user blacklist
        let user = PFUser.currentUser()
        let blacklist = user[USER_BLACKLIST_KEY] as? PFObject
        // Check to see we need to fetch object or it's already fetched
        if blacklist?.createdAt == nil {
            blacklist?.fetchInBackgroundWithBlock({ (object: PFObject!, error: NSError!) -> Void in
                if error == nil {
                    let users = object[BLACK_LIST_USERS_KEY] as? [String]
                    if let blacklistUsers = users {
                        query.whereKey(OBJECT_ID_KEY, notContainedIn: blacklistUsers)
                        self.executeQuery(query, fromAge: fromAge, toAge: toAge, sex: sex, faculty: faculty)
                    }
                } else {
                    println(error)
                }
            })
        } else {
            let users = blacklist![BLACK_LIST_USERS_KEY] as? [String]
            if let blacklistUsers = users {
                query.whereKey(OBJECT_ID_KEY, notContainedIn: blacklistUsers)
                self.executeQuery(query, fromAge: fromAge, toAge: toAge, sex: sex, faculty: faculty)
            }
        }
    }
    
    func executeQuery(query: PFQuery!, fromAge: Int?, toAge: Int?, sex: Sex?, faculty: Faculty?) {
        // Filter the query based on given arguments
        if let givenFromAge = fromAge? {
            query.whereKey(USER_AGE_KEY, greaterThanOrEqualTo: givenFromAge)
        }
        if let givenToAge = toAge? {
            query.whereKey(USER_AGE_KEY, lessThanOrEqualTo: givenToAge)
        }
        if let givenSex = sex? {
            query.whereKey(USER_GENDER_KEY, equalTo: givenSex.rawValue)
        }
        if let giveFaculty = faculty? {
            query.whereKey(USER_FACULTY_KEY, equalTo: giveFaculty.rawValue)
        }
        query.orderByDescending(UPDATED_AT_KEY)
        
        query.findObjectsInBackgroundWithBlock { (result: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                
                if let objects = result as [PFObject]! {
                    self.students = objects
                    self.tableView.reloadData()
                }
                
            } else {
                println(error)
            }
            
            AppUtility.hideProgressViewFromView(self.navigationController?.view)
            
        }

    }
    
    func setCellFromStudent(cell: FindFriendTableViewCell!, student: PFObject!) {
        // Set gender icon
        if let gender = student[USER_GENDER_KEY] as? String {
            if gender == Sex.Female.rawValue {
                cell.sexImageView.image = UIImage(named: "women-icon")
            } else {
                cell.sexImageView.image = UIImage(named: "man-icon")
            }
        }
        // Set name
        var fullName = ""
        if let firstName = student[USER_FIRST_NAME_KEY] as? String {
            fullName += firstName
        }
        if let lastName = student[USER_LAST_NAME_KEY] as? String {
            fullName = fullName + " " + lastName
        }
        cell.nameLabel.text = fullName
        
        // Set profileImage
        if let pictures = student[USER_PICTURES_KEY] as? [PFFile] {
            var profilePictureFile = pictures[0]
            profilePictureFile.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                if error == nil {
                    cell.profileImageView.image = UIImage(data: data)
                } else {
                    println(error)
                }
            })
        }

    }
    
    // MARK: - Filter delegate methods
    
    func advanceFilterDismissed(controller: FilterTableViewController,fromAge: Int?, toAge: Int?, sex: Sex?, faculty: Faculty?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        AppUtility.showProgressViewForView(self.navigationController?.view, isDimmed: true)
        
        self.filteredAgeFrom = fromAge
        self.filteredAgeTo = toAge
        self.filteredSex = sex
        self.filteredFaculty = faculty
        
        self.loadStudents(fromAge, toAge: toAge, sex: sex, faculty: faculty)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedStudent = self.students[indexPath.row]
        self.performSegueWithIdentifier("ProfileSegue", sender: self)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FindFriendCell", forIndexPath: indexPath) as FindFriendTableViewCell
        
        // check to make sure students array is not empty
        if !self.students.isEmpty {
            let student = self.students[indexPath.row]
            
            // Set table cell data
            self.setCellFromStudent(cell, student: student)
        }

        return cell
    }
    
    // MARK: - Table view action methods

    @IBAction func filterTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("FilterSegue", sender: self)
    }
    
    // set the delegation of filter table view controller to find friends view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FilterSegue" {
            let nvc = segue.destinationViewController as? UINavigationController
            let fvc = nvc?.viewControllers[0] as? FilterTableViewController
            fvc?.filterDelegate = self
        }
        
        if segue.identifier == "ProfileSegue" {
            let pvc = segue.destinationViewController as? ProfileTableViewController
            if let user = self.selectedStudent as? PFUser {
                pvc?.user = user
            }
            
        }
    }
}
