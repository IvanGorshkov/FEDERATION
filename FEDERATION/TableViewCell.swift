//
//  TableViewCell.swift
//  FEDERATION
//
//  Created by Ivan Gorshkov on 01/05/2019.
//  Copyright © 2019 Ivan Gorshkov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    var menu:ItemModel? {
        didSet{
            title.text = menu?.name
            size.text = "Размер: "+menu!.size!
            color.text = "Цвет: "+menu!.color!
            price.text = "Цена: "+menu!.price!+"₽"
            quantity.text = "Количество: "+menu!.quality!
            imgView?.sd_setImage(with: URL(string: self.menu?.img ?? "")!)
            
        }
    }
    
    
}
