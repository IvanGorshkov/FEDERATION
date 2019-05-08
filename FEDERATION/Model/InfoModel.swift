//
//  ItemModel.swift
//  FEDERATION
//
//  Created by Ivan Gorshkov on 01/05/2019.
//  Copyright © 2019 Ivan Gorshkov. All rights reserved.
//

import Foundation

class InfoModel: NSObject {
    
    //properties
    
    var profit: String?
    var qogs: String?
    var soldon: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(profit: String, qogs: String, soldon: String) {
        self.profit = profit
        self.qogs = qogs
        self.soldon = soldon
    }
    
    
    //prints object's current state
    
    
    
}
