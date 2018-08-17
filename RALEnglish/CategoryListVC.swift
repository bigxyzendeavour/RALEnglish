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
        
//        let url1 = "https://www.dropbox.com/s/hdj1es6o9uphfr2/Penguin%20Misses%20Mom.m4a?dl=1"
//        let url2 = "https://www.dropbox.com/s/urizf5mw1h1nwmd/Sheila%20The%20Sheep%202.m4a?dl=1"
//        let url3 = "https://www.dropbox.com/s/60l38qzn23xl19w/My%20potty%202.m4a?dl=1"
//        let url4 = "https://www.dropbox.com/s/we0kl08i10lbrit/Flowing%20water.MP3?dl=1"
//        urls = [url1, url2, url3, url4]
        
//        testData()
        downloadCateogyList()
    }
    
//    func testData() {
//        for i in 0..<4 {
//            let content = Content()
//            content.contentID = i
//            content.description = "\(i + i)"
//            content.title = "\(i + i + 1)"
//            contentList.append(content)
//            let model = DFPlayerModel()
//            model.audioId = UInt(NSInteger(i))
//            model.audioUrl = NSURL(string: urls[i]) as! URL
//            self.playerModels.append(model)
//        }
//        self.tableView.reloadData()
//    }
    
    func downloadCateogyList() {
        startRefreshing()
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
            if isRefreshing == true {
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Network connection issue", alertMessage: "Please scroll up to refresh", actionTitle: ["OK"])
            }
        })
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
