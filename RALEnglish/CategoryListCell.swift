//
//  CategoryListCell.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class CategoryListCell: UITableViewCell {
    
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentDescriptionLabel: UILabel!
    @IBOutlet weak var contentCellContainerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(content: Content) {
        contentCellContainerView.heightCircleView(radius: 15)
        contentTitleLabel.text = content.title
        contentDescriptionLabel.text = content.description
    }
    
    func randomColor() -> UIColor {
        let randomRed = CGFloat(arc4random_uniform(256)) / 255.0
        let randomGreen = CGFloat(arc4random_uniform(256)) / 255.0
        let randomBlue = CGFloat(arc4random_uniform(256)) / 255.0
        
        let color = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        return color
    }
    
}
