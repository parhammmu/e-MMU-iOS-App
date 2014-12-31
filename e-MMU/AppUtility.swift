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
    
    class func showProgressViewForView(aView: UIView, isDimmed : Bool) {
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
        let animationImagesName = ["bear1", "bear2", "bear3", "bear4", "bear5", "bear6", "bear7", "bear8"]
        
        var animationImages : [UIImage] = []
        for var i = 0; i < animationImagesName.count; i++ {
            animationImages.append(UIImage(named: animationImagesName[i])!)
        }
        
        let imageView = UIImageView(image: UIImage(named: "bear1"))
        imageView.animationImages = animationImages
        imageView.animationDuration = 2
        imageView.startAnimating()
        hud.customView = imageView
    }
    
    class func hideProgressViewFromView(aView : UIView) {
        MBProgressHUD.hideAllHUDsForView(aView, animated: true)
    }
}
