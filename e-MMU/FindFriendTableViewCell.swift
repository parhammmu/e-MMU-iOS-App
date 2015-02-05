//
//  FindFriendTableViewCell.swift
//  e-MMU
//
//  Created by Parham Majdabadi on 05/02/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

class FindFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupAppearance()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupAppearance() {
        self.nameLabel.font = HEADER_FONT
        self.nameLabel.textColor = MAIN_FONT_COLOUR
    }

}
