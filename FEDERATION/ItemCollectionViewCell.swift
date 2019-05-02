//
//  MovieCollectionViewCell.swift
//  Moscowich
//
//  Created by Ivan Gorshkov on 21/04/2019.
//  Copyright © 2019 goldmanspirit. All rights reserved.
//

import UIKit
import SDWebImage
class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var menu:ItemsModel? {
        didSet{
            title.text = menu?.name
            img?.sd_setImage(with: URL(string: self.menu?.img ?? ""))
            
        }
    }
}
/*
 if let url = URL(string: menu?.imglink ?? ""){
 if let data = NSData(contentsOf: url as URL){
 // itemCell.weatherimg.contentMode = UIView.ContentMode.scaleAspectFit
 img.image = UIImage(data: data as Data)
 }
 }*/
