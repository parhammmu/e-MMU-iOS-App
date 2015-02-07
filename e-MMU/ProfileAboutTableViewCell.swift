//
//  ProfileAboutTableViewCell.swift
//  e-MMU
//
//  Created by Parham Majdabadi on 07/02/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

class ProfileAboutTableViewCell: UITableViewCell {

    
    @IBOutlet weak var aboutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupAppearance()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupAppearance() {
        self.aboutLabel.font = PROFILE_BODY_FONT
        self.aboutLabel.textColor = GRAY_FONT_COLOUR
    }


}
