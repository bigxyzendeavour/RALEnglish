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

        Timer.scheduledTimer(withTimeInterval: 3.2, repeats: false) { (timer) in
            self.initView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MainCategoryVC {
            destination.selectedMainCategory = selection
        }
    }

    @IBAction func storySelected(_ sender: UITapGestureRecognizer) {
        selection = Enum().STORY
        performSegue(withIdentifier: "MainCategoryVC", sender: nil)
    }
   
    @IBAction func musicSelected(_ sender: UITapGestureRecognizer) {
        selection = Enum().MUSIC
        performSegue(withIdentifier: "MainCategoryVC", sender: nil)
    }
}
