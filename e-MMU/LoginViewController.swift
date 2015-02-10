//
//  LoginViewController.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FacultyChoosen, NSURLSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // Mark : Faculty Protocol methods
    
    func facultyDismissed() {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func loginTapped(sender: AnyObject) {
        
        AppUtility.showProgressViewForView(self.view, isDimmed: true)
        
        let permissions : [AnyObject] = ["public_profile", "email"]
        
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) -> Void in
            
            if error == nil {
                
                if user == nil {
                    NSLog("Uh oh. The user cancelled the Facebook login.")
                    
                    AppUtility.showProgressViewForView(self.view, isDimmed: true)
                } else if user.isNew {
                    
                    self.getAndSetUserInfo(user)
                    
                    self.performSegueWithIdentifier("Faculty", sender: self)
                } else {
                    
                    self.performSegueWithIdentifier("Faculty", sender: self)
                }
                
            }
            
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Faculty" {
            let fvc = segue.destinationViewController as FacultyViewController
            fvc.delegate = self;
        }
    }
    
    // Mark : Helper methods
    
    func getAndSetUserInfo(user: PFUser!) {
        
        FBRequestConnection.startForMeWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                
                if let json = result as? NSDictionary {

                    if let email = json["email"] as? String {
                        user.email = email
                    }
                    
                    if let firstName = json["first_name"] as? String {
                        user["firstName"] = firstName
                    }
                    
                    if let lastName = json["last_name"] as? String {
                        user["lastName"] = lastName
                    }
                    
                    if let gender = json["gender"] as? String {
                        user["gender"] = gender
                    }
                    
                    if let id = json["id"] as? String {
                        let profilePictureURL = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")
                        let profilePictureURLRequest = NSURLRequest(URL: profilePictureURL!)
                        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
                        
                        session.dataTaskWithRequest(profilePictureURLRequest, completionHandler: { (imageData: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                            
                            if error == nil {
                                
                                let file : PFFile = PFFile(name: "profilePicture", data: imageData!)
                                file.saveInBackgroundWithBlock({ (success, error) -> Void in
                                    if success {
                                        user.addUniqueObject(file, forKey: "pictures")
                                        user.saveEventually()
                                        
                                        AppUtility.hideProgressViewFromView(self.view)
                                    }
                                })
                                
                            } else {
                                println(error.description)
                                
                                AppUtility.hideProgressViewFromView(self.view)
                            }
                            
                        }).resume()
                    }
                    
                    user.saveEventually()
                    
                    AppUtility.hideProgressViewFromView(self.view)
                    
                }
            } else {
                println(error.description)
            }

        }
    }
    
}
