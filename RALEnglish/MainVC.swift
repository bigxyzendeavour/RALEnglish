//
//  MainVC.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-01.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedItem: String!
    var categoryList = ["0-24 Months", "2-3", "3-4", "4-5", "Vocabulary", "Something"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (collectionView.frame.width - 20)/2, height: (collectionView.frame.height - 20)/3)
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.initView.isHidden = true
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categoryList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
        cell.configureCell(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = categoryList[indexPath.item]
        performSegue(withIdentifier: "CategoryListVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CategoryListVC {
            destination.selectedCategory = selectedItem
        }
    }
    
}

