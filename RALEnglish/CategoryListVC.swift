//
//  CategoryListVC.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class CategoryListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory: String!
    var contentList = [Content]()
    var selectedContent: Content!
    var selectedContentID: Int!
    var playerModels = [DFPlayerModel]()
    var selectedPlayerModel: DFPlayerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadCateogyList()
    }
    
    func downloadCateogyList() {
        startRefreshing()
        DataService.ds.REF_BASE.child(selectedCategory).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    let contentID = snap.key
                    let data = snap.value as! Dictionary<String, Any>
                    let content = Content(contentID: contentID, contentData: data)
                    self.contentList.append(content)
                }
                for i in 0..<self.contentList.count {
                    let content = self.contentList[i]
                    let playerModel = DFPlayerModel()
                    playerModel.audioId = UInt(i)
                    playerModel.audioUrl = URL(string: content.contentURL)!
                    self.playerModels.append(playerModel)
                }
                self.tableView.reloadData()
                self.endRefrenshing()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = contentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListCell") as! CategoryListCell
        cell.configureCell(content: content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContent = contentList[indexPath.row]
        selectedContentID = indexPath.row
        selectedPlayerModel = playerModels[indexPath.row]
        performSegue(withIdentifier: "ContentPlayerVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ContentPlayerVC {
            destination.selectedContent = selectedContent
            destination.contentList = contentList
            destination.currentContentID = selectedContentID
            destination.playerModels = playerModels
            destination.selectedPlayerModel = selectedPlayerModel
        }
    }
    
    //    func orderContentListByID(contentList: [Content]) -> [Content] {
    //        var newContentList = contentList
    //        for i in 0..<contentList.count {
    //            let content = contentList[i]
    //            newContentList[] = contentList[i]
    //        }
    //        return newGroups
    //    }
    
}
