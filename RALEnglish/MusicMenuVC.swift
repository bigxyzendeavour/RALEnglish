//
//  MusicMenuVC.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-09-22.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class MusicMenuVC: UIViewController {

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
        let musicTimeView = UIView(frame: CGRect(x: x - 10, y: y, width: width, height: height))
        musicTimeView.backgroundColor = UIColor.clear
        let musicTimeTap = UITapGestureRecognizer(target: self, action: #selector(musicTimePressed))
        musicTimeTap.numberOfTapsRequired = 1
        musicTimeView.addGestureRecognizer(musicTimeTap)
        musicTimeView.isUserInteractionEnabled = true
        let sleepTimeView = UIView(frame: CGRect(x: x, y: y + height * 1.98, width: width, height: height))
        sleepTimeView.backgroundColor = UIColor.clear
        let sleepTimeTap = UITapGestureRecognizer(target: self, action: #selector(sleepTimePressed))
        sleepTimeView.addGestureRecognizer(sleepTimeTap)
        self.view.addSubview(musicTimeView)
        self.view.addSubview(sleepTimeView)
    }
    
    @objc func musicTimePressed(_ sender: UITapGestureRecognizer) {
        selectedSubCategory = Enum().MUSIC_MUSIC_TIME
        performSegue(withIdentifier: "MusicCategoryListVC", sender: nil)
    }
    
    @objc func sleepTimePressed(_ sender: UITapGestureRecognizer) {
        selectedSubCategory = Enum().MUSIC_SLEEP_TIME
        performSegue(withIdentifier: "MusicPlayerVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MusicCategoryListVC {
            destination.selectedMainCategory = selectedMainCategory
            destination.selectedSubCategory = selectedSubCategory
        }
        if let destination = segue.destination as? MusicPlayerVC {
            destination.selectedSubCategory = selectedSubCategory
        }
    }
}
