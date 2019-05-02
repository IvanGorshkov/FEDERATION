//
//  HomeModel.swift
//  SwiftDatabaseTutorial
//
//  Created by Christopher Ching on 2017-06-10.
//  Copyright © 2017 Christopher Ching. All rights reserved.
//

import UIKit

protocol DBModelKapitalProtocol: class {
    func KapitalDownloaded(items: NSArray)
}

class DBModelKapital: NSObject {

    //properties
    
    weak var delegate: DBModelKapitalProtocol!
    
    let urlPath = "http://db.dragonmaster.ru/kapitalservice.php" //this will be changed to the path where service.php lives
 
    func downloadPrice() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                print(data!)
                self.parseJSON(data!)
            }
            
        }
        
        task.resume()
    }

    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let items = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            print(jsonElement)
            let item = ItemsModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if
                let quantity = jsonElement["quantity"] as? String,
                let price = jsonElement["price"] as? String
            {
                
                item.id = quantity
                print(quantity)
                print(price)
                item.price = Int(price)
                
            }
            
            items.add(item)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.KapitalDownloaded(items: items)
            
        })
    }

}
