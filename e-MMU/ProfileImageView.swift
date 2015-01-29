//
//  ProfileImageView.swift
//  epub
//
//  Created by Parham on 13/10/2014.
//  Copyright (c) 2014 Parham Majdabadi. All rights reserved.
//

import UIKit

@IBDesignable class ProfileImageView: UIImageView {

    
    // Properties
    @IBInspectable var cornerRadius: CGFloat = 50.0 {
        didSet {setup()}
    }
    
    @IBInspectable var borderWidth: CGFloat = 3.0 {
        didSet {setup()}
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.grayColor() {
        didSet {setup()}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.image = UIImage(named: "profileImageHolder")
        self.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin;
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.borderColor = self.borderColor.CGColor
        self.layer.borderWidth = self.borderWidth;
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.layer.shouldRasterize = true;
        self.clipsToBounds = true;
    }
}
