//
//  LoginViewController.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FacultyChoosen {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // Mark : Faculty Protocol methods
    
    func facultyDismissed() {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func loginTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier("Faculty", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Faculty" {
            let fvc = segue.destinationViewController as FacultyViewController
            fvc.delegate = self;
        }
    }

}
