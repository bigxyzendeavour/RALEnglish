//
//  MusicCategoryListVC.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-08-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class MusicCategoryListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedMainCategory: String!
    var selectedSubCategory: String!
    var contentList = [MusicContent]()
    var playerModels = [DFPlayerModel]()
    var selectedContent: Content!
    var selectedContentID: Int!
    var selectedPlayerModel: DFPlayerModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        downloadCateogyList()
    }
    
    func downloadCateogyList() {
        startRefreshing()
        DispatchQueue.main.async {
            DataService.ds.REF_BASE.child(self.selectedMainCategory).child(self.selectedSubCategory).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    for i in 0..<snapShot.count {
                        let contentID = i
                        let data = snapShot[i].value as! Dictionary<String, Any>
                        let content = MusicContent(contentID: contentID, contentData: data)
                        self.contentList.append(content)
                        let model = DFPlayerModel()
                        model.audioId = UInt(NSInteger(content.contentID))
                        model.audioUrl = NSURL(string: content.contentURL)! as URL
                        self.playerModels.append(model)
                    }
                    self.tableView.reloadData()
                    self.endRefrenshing()
                }
            })
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = contentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCategoryListCell") as! MusicCategoryListCell
        cell.configureCell(content: content)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MusicPlayerVC {
            destination.selectedContent = selectedContent
            destination.contentList = contentList
            destination.currentContentID = selectedContentID
            destination.playerModels = playerModels
            destination.selectedPlayerModel = selectedPlayerModel
            destination.selectedSubCategory = selectedSubCategory
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContent = contentList[indexPath.row]
        selectedContentID = indexPath.row
        selectedPlayerModel = playerModels[indexPath.row]
        performSegue(withIdentifier: "MusicPlayerVC", sender: nil)
    }
}
