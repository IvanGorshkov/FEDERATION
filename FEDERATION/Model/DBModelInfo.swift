//
//  HomeModel.swift
//  SwiftDatabaseTutorial
//
//  Created by Christopher Ching on 2017-06-10.
//  Copyright © 2017 Christopher Ching. All rights reserved.
//

import UIKit

protocol DBModelInfoProtocol: class {
    func infoDownloaded(items: NSArray)
}

class DBModelInfo: NSObject {

    //properties
    
    weak var delegate: DBModelInfoProtocol!
    
    let urlPath = "http://db.dragonmaster.ru/read_info_service.php" //this will be changed to the path where service.php lives
 
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
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
            
            let item = InfoModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let profit = jsonElement["Profit"] as? String,
                let qogs = jsonElement["QOGS"] as? String,
                let soldOn = jsonElement["SoldOn"] as? String
            {
                
                item.profit = profit
                item.qogs = qogs
                item.soldon = soldOn
               
                
            }
            
            items.add(item)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.infoDownloaded(items: items)
            
        })
    }

}
