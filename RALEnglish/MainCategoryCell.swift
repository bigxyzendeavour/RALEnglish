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
        var categoryName: String
        switch category {
        case "0-24 Months":
            categoryName = "0-24月"
        case "2-3":
            categoryName = "2-3岁"
        case "3-4":
            categoryName = "3-4岁"
        case "4-5":
            categoryName = "4-5岁"
        case "Vocabulary":
            categoryName = "单词"
        case "Something":
            categoryName = "名句"
        default:
            categoryName = ""
            break
        }
        categoryNameLabel.text = categoryName
        categoryImageView.heightCircleView(radius: 15)
        categoryImageView.image = UIImage(named: category)
    }
}
