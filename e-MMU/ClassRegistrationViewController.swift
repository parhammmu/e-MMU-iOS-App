//
//  ClassRegistrationViewController.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

class ClassRegistrationViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.MenuNavigationSetup(self.menuButton, viewController: self, navigationController: navigationController)
    }

}
