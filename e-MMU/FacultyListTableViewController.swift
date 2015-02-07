//
//  FacultyListTableViewController.swift
//  e-MMU
//
//  Created by Parham Majdabadi on 05/02/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

protocol FacultyDelegate {
    func newFacultyChoosen(controller: FacultyListTableViewController, faculty: Faculty)
}

class FacultyListTableViewController: UITableViewController {
    
    var delegate : FacultyDelegate?
    var currentFaculty : Faculty!
    let faculties = ["All", "Faculty of Business and Law", "Faculty of Education", "Faculty of Health, Psychology and Social Care", "Faculty of Humanities, Languages and Social Science", "Faculty of Science and Engineering", "Hollings Faculty", "Manchester School of Art", "Cheshire campus"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.faculties.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.delegate?.newFacultyChoosen(self, faculty: AppUtility.getCurrentFaculty(cell?.textLabel)!)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FacultyCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.font = BODY_FONT
        cell.textLabel?.text = self.faculties[indexPath.row]
        
        if self.faculties[indexPath.row] == currentFaculty.rawValue {
            let check = UIImageView(image: UIImage(named: "check"))
            cell.accessoryView = check
        }

        return cell
    }


}
