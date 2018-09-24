//
//  MainVC.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-08-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var initView: UIView!
    
    var selection: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 2.8, repeats: false) { (timer) in
            self.initView.isHidden = true
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        initialize()
    }
    
    func initialize() {
        let width: CGFloat = 240.0
        let height: CGFloat = 105.0
        let x = (self.view.frame.size.width - width) / 2
        let y = self.view.frame.size.height / 2
        let storyBtnView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        storyBtnView.backgroundColor = UIColor.clear
        let storyTap = UITapGestureRecognizer(target: self, action: #selector(storyBtnPressed))
        storyTap.numberOfTapsRequired = 1
        storyBtnView.addGestureRecognizer(storyTap)
        storyBtnView.isUserInteractionEnabled = true
        let musicBtnView = UIView(frame: CGRect(x: x, y: y + height + 10, width: width, height: height))
        musicBtnView.backgroundColor = UIColor.clear
        let musticTap = UITapGestureRecognizer(target: self, action: #selector(musicBtnPressed))
        musicBtnView.addGestureRecognizer(musticTap)
        self.view.addSubview(storyBtnView)
        self.view.addSubview(musicBtnView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryMenuVC {
            destination.selectedMainCategory = selection
        }
        if let destination = segue.destination as? MusicMenuVC {
            destination.selectedMainCategory = selection
        }
    }
    
    @objc func storyBtnPressed(_ sender: UITapGestureRecognizer) {
        selection = Enum().STORY
        performSegue(withIdentifier: "StoryMenuVC", sender: nil)
    }
    
    @objc func musicBtnPressed(_ sender: UITapGestureRecognizer) {
        selection = Enum().MUSIC
        performSegue(withIdentifier: "MusicMenuVC", sender: nil)
    }
}
