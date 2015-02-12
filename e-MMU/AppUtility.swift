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
        } else {
            if PFUser.currentUser()["blacklist"] == nil {
                PFUser.currentUser().fetchInBackgroundWithBlock({ (object: PFObject!, error: NSError!) -> Void in

                })
                
            }
        }
        
    }
    
    class func showAgeAlerView(viewController: UIViewController) {
        let alert = UIAlertController(title: "How old are you?", message: "Sorry! Somehow we couldn't manage to retreive your age from Facebook for optimising your experience on e-MMU. \n Please enter your age!", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField : UITextField!) -> Void in
            textField.placeholder = "Your age"
            textField.keyboardType = UIKeyboardType.NumberPad
        })
        
        let okAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction!) -> Void in
            let studentAgeTextField = alert.textFields?.first as? UITextField
            if studentAgeTextField?.text != "" {
                let currentUser = PFUser.currentUser()
                
                currentUser[USER_AGE_KEY] = studentAgeTextField?.text.toInt()
                currentUser.saveEventually()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Maybe later!", style: UIAlertActionStyle.Cancel, handler: { (alertAction : UIAlertAction!) -> Void in
            viewController.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        viewController.presentViewController(alert, animated: true, completion: nil)

    }
    
    class func showProgressViewForView(aView: UIView!, isDimmed : Bool) {
        let progressView = MBProgressHUD(view: aView)
        progressView.mode = MBProgressHUDModeCustomView
        progressView.dimBackground = isDimmed
        progressView.color = UIColor.clearColor()
        self.setAnimationForProgressView(progressView)
        progressView.removeFromSuperViewOnHide = true
        aView.addSubview(progressView)
        progressView.show(true)
    }
    
    private class func setAnimationForProgressView(hud : MBProgressHUD) {
        
        let imageView = UIImageView(image: UIImage(named: "loading1"))
        imageView.animationImages = self.getAnimationImages()
        imageView.animationDuration = 2
        imageView.startAnimating()
        hud.customView = imageView
    }
    
    class func getAnimationImages() -> [UIImage] {
        let animationImagesName = ["loading1", "loading2", "loading3"]
        
        var animationImages : [UIImage] = []
        for var i = 0; i < animationImagesName.count; i++ {
            animationImages.append(UIImage(named: animationImagesName[i])!)
        }
        return animationImages

    }
    
    class func hideProgressViewFromView(aView : UIView!) {
        MBProgressHUD.hideAllHUDsForView(aView, animated: true)
    }
    
    class func imageBasedOnCategory(categoryName : String!) -> UIImage! {
        if categoryName == "Business" {
            let randomIndex = Int(arc4random_uniform(UInt32(BUSINESS_CATEGORY_IMAGES.count)))
            return UIImage(named: BUSINESS_CATEGORY_IMAGES[randomIndex])
            
        } else if categoryName == "Education" {
            let randomIndex = Int(arc4random_uniform(UInt32(EDUCATION_CATEGORY_IMAGES.count)))
            return UIImage(named: EDUCATION_CATEGORY_IMAGES[randomIndex])
        } else {
            let randomIndex = Int(arc4random_uniform(UInt32(RESEARCH_CATEGORY_IMAGES.count)))
            return UIImage(named: RESEARCH_CATEGORY_IMAGES[randomIndex])
        }
        
    }
    
    class func getCurrentFaculty(label: UILabel?) -> Faculty? {
        
        if let text = label?.text {
            switch text {
            case Faculty.Art.rawValue :
                return .Art
            case Faculty.Education.rawValue :
                return .Education
            case Faculty.Health.rawValue :
                return .Health
            case Faculty.Humanity.rawValue :
                return .Humanity
            case Faculty.Science.rawValue :
                return .Science
            case Faculty.Business.rawValue :
                return .Business
            case Faculty.Hollings.rawValue :
                return .Hollings
            case Faculty.Cheshire.rawValue :
                return .Cheshire
            default :
                return .All
            }
            
        } else {
            return nil
        }
        
    }

}
