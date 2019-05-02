//
//  ItemModel.swift
//  FEDERATION
//
//  Created by Ivan Gorshkov on 01/05/2019.
//  Copyright © 2019 Ivan Gorshkov. All rights reserved.
//

import Foundation

class ItemModel: NSObject {
    
    //properties
    
    var id: String?
    var img: String?
    var name: String?
    var size: String?
    var color: String?
    var price: String?
    var quality: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(id: String, img: String, name: String, size: String, color: String, price: String, quality: String) {
        self.id = id
        self.img = img
        self.name = name
        self.id = id
        self.img = img
        self.name = name
    }
    
    
    //prints object's current state
    
    
    
}
