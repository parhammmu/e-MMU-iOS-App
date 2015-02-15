//
//  MyAccountViewController.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class MyAccountViewController: UITableViewController, UITextFieldDelegate, FacultyDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UITextViewDelegate {
    
    var user : PFUser!
    var facultyLabel: UILabel? = nil
    var currentResponder : AnyObject?
    var newFirstName : UITextField? = nil
    var newLastName : UITextField? = nil
    var newStudentNumber : UITextField? = nil
    var newAge : UITextField? = nil
    var newAbout : UITextView? = nil
    var pictures : [PFFile]?
    var imagePicker : UIImagePickerController!
    var selectedImageToDelete : Int!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = PFUser.currentUser()
        self.pictures = self.user[USER_PICTURES_KEY] as? [PFFile]
        
        // Hide keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
        
        // Delete cell separator
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        AppUtility.MenuNavigationSetup(self.menuButton, viewController: self, navigationController: navigationController)
    }
    
    // MARK: - Helper methods
    
    func reloadImages() {
        self.pictures = self.user[USER_PICTURES_KEY] as? [PFFile]
    }
    
    func ImageSelectedToDelete(row: Int!) {
        let alert = UIAlertView(title: "Delete Image!", message: "Are you sure? Do you want to delete the selected image?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Yes")
        alert.show()
        
    }
    
    func settingUpTextViewCell(cell: UITableViewCell!, section: Int!) -> UITableViewCell {
        
        if let textField = cell.contentView.viewWithTag(1) as? UITextField {
            textField.delegate = self
            switch section {
            case 0:
                // First name
                textField.text = self.user[USER_FIRST_NAME_KEY] as? String
                self.newFirstName = textField
            case 1:
                // Last name
                textField.text = self.user[USER_LAST_NAME_KEY] as? String
                self.newLastName = textField
            case 2:
                // Age
                textField.text = "\(self.user[USER_AGE_KEY])"
                textField.keyboardType = UIKeyboardType.NumberPad
                self.newAge = textField
            case 3:
                // Student Number
                textField.text = "\(self.user[USER_STUDENT_NUMBER])"
                textField.keyboardType = UIKeyboardType.NumberPad
                self.newStudentNumber = textField
            default:
                return cell
            }
        }
        
        return cell
    }
    
    func settingUpFacultyViewCell(cell: UITableViewCell!) -> UITableViewCell {
        
        if let facultyLabel = cell.contentView.viewWithTag(2) as? UILabel {
            facultyLabel.font = BODY_FONT
            facultyLabel.textColor = GRAY_FONT_COLOUR
            facultyLabel.text = self.user[USER_FACULTY_KEY] as? String
            self.facultyLabel = facultyLabel
        }
        
        return cell
    }
    
    func settingUpAboutViewCell(cell: UITableViewCell!) -> UITableViewCell {
        if let aboutTextView = cell.contentView.viewWithTag(4) as? UITextView {
            aboutTextView.delegate = self
            aboutTextView.font = BODY_FONT
            aboutTextView.textColor = GRAY_FONT_COLOUR
            aboutTextView.backgroundColor = BG_COLOUR
            aboutTextView.text = self.user[USER_About_KEY] as? String
            self.newAbout = aboutTextView

        }
        
        return cell
    }
    
    func settingUpImageViewCell(cell: UITableViewCell!, row: Int!) -> UITableViewCell {
        if let userImageView = cell.contentView.viewWithTag(5) as? UIImageView {
            if let pics = self.pictures as [PFFile]! {
                if row < pics.count {
                    let file = pics[row]
                    file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                        userImageView.image = UIImage(data: data)
                    })
                }
            }
        }
        return cell
    }

    
    func hideKeyboard() {
        self.currentResponder?.resignFirstResponder()
    }
    
    func addImageTapped() {
        if let pics = self.pictures as [PFFile]! {
            // Check to see if user already have five images
            if pics.count >= 5 {
                let alert = UIAlertView(title: "Ooops! Sorry", message: "You have already reach the limit! \n You cannot have more than five images.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                // Instantiate the picker view
                self.imagePicker = UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(self.imagePicker.sourceType)!
                self.presentViewController(self.imagePicker!, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Imae picker controller delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        AppUtility.showProgressViewForView(self.navigationController?.view, isDimmed: true)
        
        let data = UIImagePNGRepresentation(image)
        let file = PFFile(name: "image\(self.user.objectId)", data: data)
        file.saveInBackgroundWithBlock { (success, error: NSError!) -> Void in
            if error == nil && success == true {
                if var pics = self.pictures as [PFFile]! {
                    pics.append(file)
                    self.user[USER_PICTURES_KEY] = pics
                    self.user.saveInBackgroundWithBlock({ (successTwo: Bool, errorTwo: NSError!) -> Void in
                        self.reloadImages()
                        self.tableView.reloadData()
                    })
                }
            } else {
                let alert = UIAlertView(title: "Ooops! Error", message: "Sorry! Something went wrong, please try again!", delegate: self, cancelButtonTitle: "OK")
                alert.show()

            }
            AppUtility.hideProgressViewFromView(self.navigationController?.view)
        }
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Alert view delegate methods
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        // Delete image
        if buttonIndex == 1 {
            if var pics = self.pictures as [PFFile]! {
                pics.removeAtIndex(self.selectedImageToDelete)
                self.user[USER_PICTURES_KEY] = pics
                self.user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    self.reloadImages()
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: - UITextView delegate
    func textViewDidEndEditing(textView: UITextView) {
        self.user[USER_About_KEY] = textView.text
        self.user.saveEventually()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.currentResponder = textView
    }
    
    // MARK: - UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentResponder = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == self.newFirstName?.text {
            self.user[USER_FIRST_NAME_KEY] = textField.text
        }
        if textField.text == self.newLastName?.text {
            self.user[USER_LAST_NAME_KEY] = textField.text
        }
        if textField.text == self.newAge?.text {
            self.user[USER_AGE_KEY] = textField.text.toInt()
        }
        if textField.text == self.newStudentNumber?.text {
            self.user[USER_STUDENT_NUMBER] = textField.text.toInt()
        }
        self.user.saveEventually()
    }
    
    // MARK: - Faculty delegate methods
    
    func newFacultyChoosen(controller: FacultyListTableViewController, faculty: Faculty) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.user[USER_FACULTY_KEY] = faculty.rawValue
        self.user.saveEventually()
        self.tableView.reloadData()
    }

    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If is the image cell return the number of available pictures
        if section == 6 {
            if let pics = self.pictures as [PFFile]! {
                return pics.count
            }
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 5 {
            return 150
        }
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
        var label : UILabel!
        // Creating add button if section is images section
        if section == 6 {
            label = UILabel(frame: CGRectMake(15, 20, self.tableView.frame.width - 130, 20))
            let addButton = UIButton(frame: CGRectMake(label.frame.width + 80, 20, 50, 20))
            addButton.setImage(UIImage(named: "add_btn"), forState: UIControlState.Normal)
            addButton.backgroundColor = UIColor.clearColor()
            addButton.addTarget(self, action: "addImageTapped", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(addButton)
        } else {
            label = UILabel(frame: CGRectMake(15, 20, self.tableView.frame.width - 30, 20))
        }
        
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
            label.text = "About Me"
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
            return self.settingUpFacultyViewCell(cell)
        case 5:
            cell = tableView.dequeueReusableCellWithIdentifier("AboutCell", forIndexPath: indexPath) as UITableViewCell
            return self.settingUpAboutViewCell(cell)
        case 6:
            cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as UITableViewCell
            return self.settingUpImageViewCell(cell, row: indexPath.row)
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("TextViewCell", forIndexPath: indexPath) as UITableViewCell
            return self.settingUpTextViewCell(cell, section: indexPath.section)
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 4 {
            self.performSegueWithIdentifier("FacultySegue", sender: self)
        }
        if indexPath.section == 6 {
            self.selectedImageToDelete = indexPath.row
            self.ImageSelectedToDelete(indexPath.row)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FacultySegue" {
            let flvc = segue.destinationViewController as? FacultyListTableViewController
            if let faculty = AppUtility.getCurrentFaculty(self.facultyLabel) {
                flvc?.delegate = self
                flvc?.currentFaculty = faculty
            }
            
        }
    }

}
