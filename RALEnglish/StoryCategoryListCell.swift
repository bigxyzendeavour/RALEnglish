//
//  StoryCategoryListCell.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import FoldingCell
import Firebase

protocol StoryCategoryListCellDlegate {
    func playSelectedContent(button: UIButton)
}

class StoryCategoryListCell: FoldingCell {
    
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentDescriptionLabel: UILabel!
    @IBOutlet weak var contentAuthorLabel: UILabel!
    @IBOutlet weak var contentDisplayImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    
    var delegate: StoryCategoryListCellDlegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.heightCircleView()
    }
    
    func configureCell(content: StoryContent) {
//        contentCellContainerView.heightCircleView(radius: 15)
        contentTitleLabel.text = content.title
        contentAuthorLabel.text = "by -\(content.author)"
        contentDescriptionLabel.text = content.description
        if content.contentDisplayURL != "" {
            Storage.storage().reference(forURL: content.contentDisplayURL).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("\(String(describing: error?.localizedDescription))")
                } else {
                    let image = UIImage(data: data!)
                    self.contentDisplayImage.image = image
                }
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func animationDuration(_ itemIndex:Int, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.playSelectedContent(button: sender)
        }
        
    }
    
    @IBAction func playIconPressed(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.playSelectedContent(button: sender)
        }
    }
    
}
