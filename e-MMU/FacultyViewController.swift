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

class FacultyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: FacultyChoosen? = nil
    let faculties = [" --- ", "Faculty of Business and Law", "Faculty of Education", "Faculty of Health, Psychology and Social Care", "Faculty of Humanities, Languages and Social Science", "Faculty of Science and Engineering", "Hollings Faculty", "Manchester School of Art", "Cheshire campus"]
    @IBOutlet weak var facultyViewPicker: UIPickerView!
    @IBOutlet weak var continueButton: UIButton!
    var selectedFaculty : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.facultyViewPicker.delegate = self
        self.facultyViewPicker.dataSource = self
        
        self.continueButton.enabled = false

    }
    
    // Mark : PickerView delegate and data source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.faculties.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.faculties[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            self.continueButton.enabled = false
        } else {
            self.continueButton.enabled = true
            self.selectedFaculty = self.faculties[row]
        }
    }

    @IBAction func continueTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        if delegate != nil {
            
            let user = PFUser.currentUser()
            
            user["faculty"] = self.selectedFaculty
            
            user.saveEventually()
            
            delegate!.facultyDismissed()
            
        }
    }
    
}
