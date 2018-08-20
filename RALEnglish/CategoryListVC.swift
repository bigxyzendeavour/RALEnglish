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
//    var urls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadCateogyList()
    }

    func downloadCateogyList() {
        startRefreshing()
        DispatchQueue.main.async {
            DataService.ds.REF_BASE.child(self.selectedCategory).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    for i in 0..<snapShot.count {
                        let contentID = i
                        let data = snapShot[i].value as! Dictionary<String, Any>
                        let content = Content(contentID: contentID, contentData: data)
                        self.contentList.append(content)
                        let model = DFPlayerModel()
                        model.audioId = UInt(NSInteger(content.contentID))
                        model.audioUrl = NSURL(string: content.contentURL) as! URL
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
}
