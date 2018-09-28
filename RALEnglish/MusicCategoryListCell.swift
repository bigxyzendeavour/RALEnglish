//
//  MusicCategoryListCell.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-08-28.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class MusicCategoryListCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var musicTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(content: MusicContent) {
        containerView.heightCircleView(radius: 10)
        musicTitleLabel.text = "\(content.contentID + 1). \(content.title)"
    }

}
