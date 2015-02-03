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
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var heroLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Activate the menu
        AppUtility.MenuNavigationSetup(self.menuButton, viewController: self, navigationController: navigationController)
        
        self.heroLabel.textColor = MAIN_FONT_COLOUR
        self.heroLabel.font = BODY_FONT
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let studentNumber = PFUser.currentUser()["studentNumber"] as? Int {
            
            AppUtility.showProgressViewForView(self.view, isDimmed: true)
            
            let qrCode = self.createQRForString(studentNumber)
            let qrCodeImg = self.createNonInterpolatedUIImageFromCIImage(qrCode, scale: 2 * UIScreen.mainScreen().scale)
            self.qrImageView.image = qrCodeImg
            
            AppUtility.hideProgressViewFromView(self.view)
            
        } else {
            self.qrImageView.image = UIImage(named: "qr-holder")
            
            self.showAlertView()
        }
        
        
    }
    
    // Mark : Helper methods
    
    func createQRForString(studentNumber: Int!) -> CIImage {
        
        // Need to convert the string to a UTF-8 encoded NSData objec
        let stringData = String(studentNumber!)
        let data = stringData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        // Create the filter
        let qrFiler = CIFilter(name: "CIQRCodeGenerator")
        // Set the message content and error-correction level
        qrFiler.setValue(data, forKey: "inputMessage")
        qrFiler.setValue("H", forKey: "inputCorrectionLevel")
        
        return qrFiler.outputImage
    }
    
    func createNonInterpolatedUIImageFromCIImage(image : CIImage, scale : CGFloat) -> UIImage {
        // Render the CIImage into a CGImage
        let cgImage = CIContext(options: nil).createCGImage(image, fromRect: image.extent())
        
        // Now we'll rescale using CoreGraphics
        UIGraphicsBeginImageContext(CGSizeMake(image.extent().width * scale, image.extent().height * scale ))
        let context = UIGraphicsGetCurrentContext()
        
        // We don't want to interpolate (since we've got a pixel-correct image)
        CGContextSetInterpolationQuality(context, kCGInterpolationNone)
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage)
        
        // Get the image out
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Tidy up
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    
    func showAlertView() {
        let alert = UIAlertController(title: "Student Number", message: "Please enter your student number if you have one!", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField : UITextField!) -> Void in
            textField.placeholder = "Student Number"
            textField.keyboardType = UIKeyboardType.NumberPad
        })
        
        let okAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction!) -> Void in
            let studentNumberTextField = alert.textFields?.first as? UITextField
            if studentNumberTextField?.text != "" {
                let currentUser = PFUser.currentUser()
                
                currentUser["studentNumber"] = studentNumberTextField?.text.toInt()
                currentUser.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
                        self.viewDidAppear(true)
                    }
                })
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction : UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)

    }

}
