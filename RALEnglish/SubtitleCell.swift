//
//  SubtitleCell.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-08-07.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class SubtitleCell: UITableViewCell {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(subtitle: String) {
        subtitleLabel.text = subtitle
    }
    
}
