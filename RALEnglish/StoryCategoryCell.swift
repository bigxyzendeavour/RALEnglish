//
//  StoryCategoryCell.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-08-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class StoryCategoryCell: UITableViewCell {
    
    @IBOutlet weak var storyCategoryLabel: UILabel!
    @IBOutlet weak var storyCategoryImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(image: UIImage, categoryName: String) {
        storyCategoryImage.image = image
        storyCategoryLabel.text = categoryName
    }
}
