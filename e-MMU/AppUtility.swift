//
//  AppUtility.swift
//  e-MMU
//
//  Created by Parham on 25/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

class AppUtility: NSObject {

    class func MenuNavigationSetup(menuButton: UIBarButtonItem, viewController : UIViewController, navigationController : UINavigationController?) {
        let revealViewController = viewController.revealViewController()
        menuButton.target = viewController.revealViewController()
        menuButton.action = "revealToggle:"
        navigationController?.navigationBar.addGestureRecognizer(viewController.revealViewController().panGestureRecognizer())
    }
    
    class func checkUser(vc : UIViewController) {
        let user = PFUser.currentUser()
        let lvc = LoginViewController()
        if user == nil {
            vc.performSegueWithIdentifier("Login", sender: vc)
        }
    }
}
