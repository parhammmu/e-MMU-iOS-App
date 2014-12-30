//
//  FacultyViewController.swift
//  e-MMU
//
//  Created by Parham on 30/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

protocol FacultyChoosen {
    
    func facultyDismissed()
    
}

class FacultyViewController: UIViewController {
    
    var delegate: FacultyChoosen? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func continueTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if delegate != nil {
            
            delegate!.facultyDismissed()
            
        }
    }
    
}
