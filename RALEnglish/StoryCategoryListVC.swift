//
//  StoryCategoryListVC.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import FoldingCell

fileprivate struct C {
    struct CellHeight {
        static let close: CGFloat = 100
        static let open: CGFloat = 440
    }
}

class StoryCategoryListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, StoryCategoryListCellDlegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedMainCategory: String!
    var selectedSubCategory: String!
    var contentList = [StoryContent]()
    var selectedContent: Content!
    var selectedContentID: Int!
    var selectedPlayerModel: DFPlayerModel!
    var previousSelectedContentID: Int!
    var playerModels = [DFPlayerModel]()
    var cellHeights: [CGFloat] = []
    var openCellIndex: Int!
    var openCell: StoryCategoryListCell!
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = ""
    }
    
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
                        let content = StoryContent(contentID: contentID, contentData: data)
                        self.contentList.append(content)
                    }
                    self.contentList = self.reorderContentlist()
                    
                    print("The palyerModels array is: ")
                    for i in 0..<self.contentList.count {
                        let content = self.contentList[i]
                        let model = DFPlayerModel()
                        model.audioId = UInt(NSInteger(i))
                        print(model.audioId)
                        model.audioUrl = NSURL(string: content.contentURL) as! URL
                        print(model.audioUrl)
                        self.playerModels.append(model)
                    }
                    self.cellHeights = Array(repeating: C.CellHeight.close, count: self.contentList.count)
                    self.tableView.reloadData()
                    
                    self.endRefrenshing()
                }
            })
        }
        
    }
    
    func reorderContentlist() -> [StoryContent] {
        let newContentlist = self.contentList.sorted(by: {$0.title.lowercased() < $1.title.lowercased()})
        return newContentlist
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = contentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCategoryListCell") as! StoryCategoryListCell
        cell.foregroundView.heightCircleView(radius: 15)
        cell.delegate = self
        cell.configureCell(content: content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! StoryCategoryListCell
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == C.CellHeight.close
        if cellIsCollapsed == true {
            if openCell != nil {
                let visibleCells = tableView.visibleCells as! [StoryCategoryListCell]
                if visibleCells.contains(openCell) {
                    let index = tableView.indexPath(for: openCell!)
                    cellHeights[index!.row] = C.CellHeight.close
                    openCell.unfold(false, animated: true, completion: nil)
                    openCell = nil
                }
            }
            let openContent = contentList[indexPath.row]
            self.title = openContent.title
            cellHeights[indexPath.row] = C.CellHeight.open
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
            openCell = cell
        } else {
            self.title = ""
            cellHeights[indexPath.row] = C.CellHeight.close
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let cell as StoryCategoryListCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                cell.unfold(false, animated: false, completion:nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryPlayerVC {
            destination.selectedContent = selectedContent
            destination.contentList = contentList
            destination.currentContentID = selectedContentID
            destination.playerModels = playerModels
            destination.selectedPlayerModel = selectedPlayerModel
            destination.selectedMainCategory = selectedMainCategory
        }
    }
    
    func playSelectedContent(button: UIButton) {
        if let indexPath = tableView.indexPathForView(button) {
            print("Button tapped at indexPath \(indexPath)")
            selectedContent = contentList[indexPath.row]
            print(selectedContent.title)
            selectedContentID = indexPath.row
            print(selectedContentID)
            selectedPlayerModel = playerModels[indexPath.row]
            print(selectedPlayerModel.audioId)
            print(selectedPlayerModel.audioUrl)
            performSegue(withIdentifier: "StoryPlayerVC", sender: nil)
        }
        else {
            print("Button indexPath not found")
        }
        
    }
}
