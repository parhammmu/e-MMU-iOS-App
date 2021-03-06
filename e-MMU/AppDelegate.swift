//
//  AppDelegate.swift
//  e-MMU
//
//  Created by Parham on 22/12/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Parse setup
        ParseCrashReporting.enable()
        Parse.setApplicationId("oBYGdBE3UxlDD5eoGOoLT8SzXsk9wa3sinAtyCPK", clientKey: "pK14x4Xl4jSsRrHsYWKldF7BlS1inVo02yyv1yiW")
        //Parse.enableLocalDatastore()
        
        PFFacebookUtils.initializeFacebook()
        
        let userNotificationTypes = (UIUserNotificationType.Alert |
            UIUserNotificationType.Badge |
            UIUserNotificationType.Sound);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        self.customSetup()
        
        // Extract the notification data
        //let notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]
    
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveEventually()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        PFFacebookUtils.session().close()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }
    
    func customSetup() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UINavigationBar.appearance().barTintColor = NAVIGATION_COLOUR
        UINavigationBar.appearance().tintColor = NAVIGATION_TINT_COLOUR
        UITableViewCell.appearance().backgroundColor = BG_COLOUR
        UITableView.appearance().backgroundColor = BG_COLOUR
        UITableView.appearance().tableFooterView = UIView(frame: CGRectZero)
        UILabel.appearance().textColor = BODY_FONT_COLOUR
        UIButton.appearance().backgroundColor = BUTTON_COLOUR
        UIButton.appearance().titleLabel?.textColor = UIColor.whiteColor()
        UIButton.appearance().titleLabel?.font = BUTTON_FONT
        UIButton.appearance().tintColor = UIColor.whiteColor()
        UIButton.appearance().layer.cornerRadius = 20
        UIButton.appearance().layer.masksToBounds = true
        UITextField.appearance().borderStyle = .None
        UITextField.appearance().font = BODY_FONT
        UISwitch.appearance().tintColor = NAVIGATION_COLOUR
        UISwitch.appearance().onTintColor = NAVIGATION_COLOUR
    }

}

