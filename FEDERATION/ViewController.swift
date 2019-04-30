//
//  ViewController.swift
//  ФEDERATION
//
//  Created by Ivan Gorshkov on 30/04/2019.
//  Copyright © 2019 Ivan Gorshkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,DBModelProtocol{
    
    var feedItems: NSArray = NSArray()
    var selectedItem : ItemsModel = ItemsModel()
    @IBOutlet weak var collectionview: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for:  indexPath) as? MovieCollectionViewCell {
            let item: ItemsModel = feedItems[indexPath.row] as! ItemsModel
            itemCell.menu =  item
            
            return itemCell
        }
        
        return UICollectionViewCell()
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.collectionview.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        
        let homeModel = DBModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        // Do any additional setup after loading the view.
    }
    
    
}

