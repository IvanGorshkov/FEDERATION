//
//  LocationModel.swift
//  SwiftDatabaseTutorial
//
//  Created by Christopher Ching on 2017-06-10.
//  Copyright © 2017 Christopher Ching. All rights reserved.
//

import UIKit

class ItemsModel: NSObject {

    //properties
    
    var id: String?
    var img: String?
    var name: String?
    var price: Int?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(id: String, img: String, name: String, price: Int) {
        
        self.id = id
        self.img = img
        self.name = name
        self.price = price
        
    }
    
    
    //prints object's current state
    
   
    
}
