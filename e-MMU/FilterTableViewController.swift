//
//  FilterTableViewController.swift
//  e-MMU
//
//  Created by Parham Majdabadi on 05/02/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

protocol FilterDelegate {
    func advanceFilterDismissed(controller: FilterTableViewController, fromAge: Int?, toAge: Int?, sex: Sex?, faculty: Faculty?)
}

class FilterTableViewController: UITableViewController, FacultyDelegate {
    
    var filterDelegate : FilterDelegate?
    let check = UIImageView(image: UIImage(named: "check"))
    var choosenFaculty : Faculty? = nil
    var choosenSex : Sex? = nil
    
    @IBOutlet weak var ageSlider: NMRangeSlider!
    @IBOutlet weak var lowerRangeLabel: UILabel!
    @IBOutlet weak var upperRangeLabel: UILabel!
    @IBOutlet weak var facultyLabel: UILabel!
    @IBOutlet weak var bothGenderCell: UITableViewCell!
    @IBOutlet weak var maleGenderCell: UITableViewCell!
    @IBOutlet weak var femaleGenderCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAgeSlider()
        
        self.facultyLabel.font = BODY_FONT
        
        self.bothGenderCell.accessoryView = self.check
        
    }
    
    // MARK: - Helper methods
    
    func setupAgeSlider() {
        self.ageSlider.backgroundColor = BG_COLOUR
        self.ageSlider.tintColor = NAVIGATION_COLOUR
        self.ageSlider.minimumValue = 0
        self.ageSlider.maximumValue = 100
        self.ageSlider.lowerValue = 0
        self.ageSlider.upperValue = 100
        self.ageSlider.minimumRange = 5
        self.ageSlider.stepValue = 1
        self.lowerRangeLabel.font = BODY_FONT
        self.upperRangeLabel.font = BODY_FONT
        self.lowerRangeLabel.textColor = MAIN_FONT_COLOUR
        self.upperRangeLabel.textColor = MAIN_FONT_COLOUR

    }
    
    
    func updateSliderLabels() {
        self.lowerRangeLabel.text = "\(Int(self.ageSlider.lowerValue))"
        self.upperRangeLabel.text = "\(Int(self.ageSlider.upperValue))"
        
    }
    
    // MARK: - Faculty delegate methods
    
    func newFacultyChoosen(controller: FacultyListTableViewController, faculty: Faculty) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.choosenFaculty = faculty
        self.facultyLabel.text = faculty.rawValue
    }

    // MARK: - Table view data source and delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // If selection belongs to gendert section
        if indexPath.section == 2 {
            // Remove all ticks from cells
            self.bothGenderCell.accessoryView = nil
            self.maleGenderCell.accessoryView = nil
            self.femaleGenderCell.accessoryView = nil
            // Add tick to relevant cell
            switch indexPath.row {
            case 1:
                self.maleGenderCell.accessoryView = self.check
                self.choosenSex = Sex.Male
            case 2:
                self.femaleGenderCell.accessoryView = self.check
                self.choosenSex = Sex.Female
            default:
                self.bothGenderCell.accessoryView = self.check
            }
        }
    }
    
    // MARK: - Table view action methods
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sliderValueChaned(sender: NMRangeSlider) {
        self.updateSliderLabels()
    }
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        self.filterDelegate?.advanceFilterDismissed(self, fromAge: Int(self.ageSlider.lowerValue), toAge: Int(self.ageSlider.upperValue), sex: self.choosenSex, faculty: self.choosenFaculty)
        
    }

}
