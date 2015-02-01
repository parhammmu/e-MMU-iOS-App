//
//  NewsTableViewCell.swift
//  e-MMU
//
//  Created by Parham on 22/01/2015.
//  Copyright (c) 2015 Parham Majdabadi. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excerptLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAppearance()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupAppearance() {
        self.titleLabel.font = HEADER_FONT
        self.excerptLabel.font = BODY_FONT
        self.titleLabel.textColor = MAIN_FONT_COLOUR
        self.excerptLabel.textColor = MAIN_FONT_COLOUR
    }

}
