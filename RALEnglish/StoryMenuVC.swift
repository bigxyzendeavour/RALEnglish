//
//  StoryMenuVC.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-08-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class StoryMenuVC: UIViewController {
    
    var selectedMainCategory: String!
    var selectedSubCategory: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        let width: CGFloat = 185
        let height: CGFloat = 55
        let x = (self.view.frame.size.width - width) / 2
        let y = self.view.frame.size.height / 2
        let storyTimeView = UIView(frame: CGRect(x: x - 10, y: y, width: width, height: height))
        storyTimeView.backgroundColor = UIColor.clear
        let storyTimeTap = UITapGestureRecognizer(target: self, action: #selector(storyTimePressed))
        storyTimeTap.numberOfTapsRequired = 1
        storyTimeView.addGestureRecognizer(storyTimeTap)
        storyTimeView.isUserInteractionEnabled = true
        let sleepTimeView = UIView(frame: CGRect(x: x, y: y + height * 1.98, width: width, height: height))
        sleepTimeView.backgroundColor = UIColor.clear
        let sleepTimeTap = UITapGestureRecognizer(target: self, action: #selector(sleepTimePressed))
        sleepTimeView.addGestureRecognizer(sleepTimeTap)
        self.view.addSubview(storyTimeView)
        self.view.addSubview(sleepTimeView)
    }
    
    @objc func storyTimePressed(_ sender: UITapGestureRecognizer) {
        selectedSubCategory = Enum().STORY_STORY_TIME
        performSegue(withIdentifier: "StoryCategoryListVC", sender: nil)
    }
    
    @objc func sleepTimePressed(_ sender: UITapGestureRecognizer) {
        selectedSubCategory = Enum().STORY_SLEEP_TIME
        performSegue(withIdentifier: "StoryCategoryListVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryCategoryListVC {
            destination.selectedMainCategory = selectedMainCategory
            destination.selectedSubCategory = selectedSubCategory
        }
        
    }
}
