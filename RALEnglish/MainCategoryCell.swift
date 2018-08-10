//
//  MainCategoryCell.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class MainCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    func configureCell(category: String) {
        
        categoryNameLabel.text = category
        categoryImageView.heightCircleView(radius: 15)
        categoryImageView.image = UIImage(named: category)
    }
}
