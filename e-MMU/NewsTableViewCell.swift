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
        
    }

}
