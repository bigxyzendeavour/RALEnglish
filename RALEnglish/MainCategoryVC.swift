//
//  MainCategoryVC.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-08-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class MainCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedMainCategory: String!
    var selectedSubCategory: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedMainCategory

        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellImage = UIImage()
        var categoryName = ""
        switch indexPath.row {
        case 0:
            if selectedMainCategory == Enum().STORY {
                cellImage = UIImage(named: "StoryTime")!
                categoryName = "Story Time"
            }
            
            if selectedMainCategory == Enum().MUSIC {
                cellImage = UIImage(named: "MusicTime")!
                categoryName = "Music Time"
            }
            break
        case 1:
            if selectedMainCategory == Enum().STORY {
                cellImage = UIImage(named: "SleepTime")!
                categoryName = "Sleep Time"
            }
            
            if selectedMainCategory == Enum().MUSIC {
                cellImage = UIImage(named: "Lullbaby")!
                categoryName = "Sleep Time"
            }
            
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCategoryCell") as! StoryCategoryCell
        cell.configureCell(image: cellImage, categoryName: categoryName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedMainCategory == Enum().STORY {
            if indexPath.row == 0 {
                selectedSubCategory = Enum().STORY_STORY_TIME
            } else {
                selectedSubCategory = Enum().STORY_SLEEP_TIME
            }
            performSegue(withIdentifier: "StoryCategoryListVC", sender: nil)
        } else {
            if indexPath.row == 0 {
                selectedSubCategory = Enum().MUSIC_MUSIC_TIME
                performSegue(withIdentifier: "MusicCategoryListVC", sender: nil)
            } else {
                selectedSubCategory = Enum().MUSIC_SLEEP_TIME
                performSegue(withIdentifier: "MusicPlayerVC", sender: nil)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height - 64) / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryCategoryListVC {
            destination.selectedMainCategory = selectedMainCategory
            destination.selectedSubCategory = selectedSubCategory
        }
        if let destination = segue.destination as? MusicCategoryListVC {
            destination.selectedMainCategory = selectedMainCategory
            destination.selectedSubCategory = selectedSubCategory
        }
        if let destination = segue.destination as? MusicPlayerVC {
            destination.selectedSubCategory = selectedSubCategory
        }
    }
}
