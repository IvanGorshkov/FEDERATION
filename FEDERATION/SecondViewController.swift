//
//  SecondViewController.swift
//  FEDERATION
//
//  Created by Ivan Gorshkov on 01/05/2019.
//  Copyright © 2019 Ivan Gorshkov. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let items = NSMutableArray()
    var linktitle:String = ""
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let castedCell = cell as? TableViewCell {
            let item: ItemModel = items[indexPath.row] as! ItemModel
            castedCell.menu =  item
            return castedCell
        }
        return UITableViewCell()
    }
    
    
    func getdata(titlename:String)  {
        items.removeAllObjects()
        let request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/ShowItem.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(titlename)"
        self.navigationItem.title = linktitle
        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            self.parseJSON(data!)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata(titlename: linktitle)
    }
    

    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let item = ItemModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let id = jsonElement["id"] as? String,
                let img = jsonElement["img"] as? String,
                let title = jsonElement["title"] as? String,
                let size = jsonElement["size"] as? String,
                let color = jsonElement["color"] as? String,
                let price = jsonElement["price"] as? String,
                 let quantity = jsonElement["quantity"] as? String
            {
                
                item.name = title
               
                item.id = id
                
                item.img = "http://db.dragonmaster.ru/doc/"+img
                
                item.size = size
                
                item.color = color
                
                item.price = price
                
                item.quality = quantity
                
                
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.items.add(item)
               self.tableView.reloadData()
            })
            
            print(items)
        }
        
       
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
        
        
    }
func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        ->   UISwipeActionsConfiguration? {
            
            // Get current state from data source
        
            
            var title = "Изменить цену"
            
            let actionprice = UIContextualAction(style: .normal, title: title,
                                            handler: { (action, view, completionHandler) in
                                                // Update data source when user taps action
                                                let alert = UIAlertController(title: "Изменить цену", message: "Введите цену вещи", preferredStyle: .alert)
                                                
                                                //2. Add the text field. You can configure it however you need.
                                                alert.addTextField { (textField) in
                                                }
                                                
                                                // 3. Grab the value from the text field, and print it when the user clicks OK.
                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                                                    let textField = alert?.textFields![0]
                                                    let item: ItemModel = self.items[indexPath.row] as! ItemModel
                                                    guard textField!.text! != "" else {
                                                        return
                                                    }
                                                    self.changeprice(id: Int(item.id!)!, price: Int((textField?.text!)!)!)
                                                    
                                                }))
                                                
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                completionHandler(true)
            })
             title = "Изменить количесвто"
            
            let actionqual = UIContextualAction(style: .normal, title: title,
                                            handler: { (action, view, completionHandler) in
                                                //1. Create the alert controller.
                                                let alert = UIAlertController(title: "Изменить количесвто вещей", message: "Введите количество вещей", preferredStyle: .alert)
                                                
                                                //2. Add the text field. You can configure it however you need.
                                                alert.addTextField { (textField) in
                                                }
                                                
                                                // 3. Grab the value from the text field, and print it when the user clicks OK.
                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                                                    let textField = alert?.textFields![0]
                                                    let item: ItemModel = self.items[indexPath.row] as! ItemModel
                                                    guard textField!.text! != "" else {
                                                        return
                                                    }
                                                    self.changequal(id: Int(item.id!)!, qual: Int(textField!.text!)!)
                                                    
                                                }))
                                                
                                                self.present(alert, animated: true, completion: nil)
                                                
                                              //  tableView.reloadData()
                                                completionHandler(true)
            })
            
           // action.image = UIImage(named: "heart")
            actionqual.backgroundColor = .lightGray
            actionprice.backgroundColor = .darkGray
            let configuration = UISwipeActionsConfiguration(actions: [actionqual,actionprice])
            return configuration
    }
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            
            let ourSell = NSLocalizedString("Наша продажа", comment: "Our Sell")
            let ourSellAction = UITableViewRowAction(style: .destructive,
                                                    title: ourSell) { (action, indexPath) in
                                                        
                                                        let alert = UIAlertController(title: "Продажа", message: "Введите ритейл", preferredStyle: .alert)
                                                        
                                                        //2. Add the text field. You can configure it however you need.
                                                        alert.addTextField { (textField) in
                                                        }
                                                        
                                                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                                                            let textField = alert?.textFields![0]
                                                            let item: ItemModel = self.items[indexPath.row] as! ItemModel
                                                            var profit:Int?
                                                            guard textField!.text! != "" else {
                                                                return
                                                            }
                                                            if (Int(item.quality!) == 1) {
                                                                 profit = Int(item.price!)! - Int(textField!.text!)!
                                                                self.profit(profitint: profit!)
                                                                self.sell(soldon: Int(item.price!)!)
                                                                self.removeitem(id: Int(item.id!)!)
                                                            }
                                                            else{
                                                                profit = Int(item.price!)! - Int(textField!.text!)!
                                                                self.profit(profitint: profit!)
                                                                self.sell(soldon: Int(item.price!)!)
                                                                self.reduceQ(reduceQ: Int(item.id!)!)
                                                            }
                                                        }))
                                                        self.present(alert, animated: true, completion: nil)
                                                        
            }
            
            let implementation = NSLocalizedString("Реализация", comment: "Implementation action")
            let implementationAction = UITableViewRowAction(style: .normal,
                                                      title: implementation) { (action, indexPath) in
                                                        
                                                        let alert = UIAlertController(title: "Продажа", message: "Введите процент", preferredStyle: .alert)
                                                        
                                                        //2. Add the text field. You can configure it however you need.
                                                        alert.addTextField { (textField) in
                                                        }
                                                        
                                                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                                                            let textField = alert?.textFields![0]
                                                            let item: ItemModel = self.items[indexPath.row] as! ItemModel
                                                            var profit:Int?
                                                            guard textField!.text! != "" else {
                                                                return
                                                            }
                                                            if (Int(item.quality!) == 1) {
                                                                profit = Int(item.price!)! * Int(textField!.text!)!/100
                                                                self.profit(profitint: profit!)
                                                                self.sell(soldon: Int(item.price!)!)
                                                        self.removeitem(id: Int(item.id!)!)
                                                            }
                                                            else{
                                                                profit = Int(item.price!)! * Int(textField!.text!)!/100
                                                                
                                                                self.profit(profitint: profit!)
                                                                self.sell(soldon: Int(item.price!)!)
                                                                self.reduceQ(reduceQ: Int(item.id!)!)
                                                            }
                                                            
                                                        }))
                                                        
                                                        self.present(alert, animated: true, completion: nil)
                                                        
                                                        
                                                       
            }
            let removeOfSelling = NSLocalizedString("Снят с продажи", comment: "Remove from sell")
            let removeOfSellingAction = UITableViewRowAction(style: .normal,
                                                            title: removeOfSelling) { (action, indexPath) in
                                                                let item: ItemModel = self.items[indexPath.row] as! ItemModel
                                                                 if (Int(item.quality!) == 1) {
                                                                    
                                                                self.removeitem(id: Int(item.id!)!)
                                                                }
                                                                 else{
                                                                    self.reduceQ(reduceQ: Int(item.id!)!)
                                                                }
            }
            ourSellAction.backgroundColor = .green
            implementationAction.backgroundColor = .init(red: 38/255, green: 177/255, blue: 46/255, alpha: 1)
             removeOfSellingAction.backgroundColor = .red
            return [ourSellAction,implementationAction, removeOfSellingAction]
    }
    
    
    
    func changequal(id:Int, qual:Int) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/change_quantity_service.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(id)&b=\(qual)"
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.getdata(titlename: self.linktitle)
                self.tableView.reloadData()
            });
        }
        task.resume()
    }
 
    func reduceQ(reduceQ:Int) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/reduceQ_service.php")! as URL)
        request.httpMethod = "POST"
        let postString = "a=\(reduceQ)"
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.getdata(titlename: self.linktitle)
                self.tableView.reloadData()
            });
            
        }
        task.resume()
    }
    
     func profit(profitint:Int) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/profit_service.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(profitint)"
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    func sell(soldon:Int) {
        
        
        var request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/QOGService.php")! as URL)
        
       var  task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        
         request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/soldon_service.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(soldon)"
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
         task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        
    }
    
    
    
    func changeprice(id:Int, price:Int) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/change_price_service.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(id)&b=\(price)"
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            DispatchQueue.main.async(execute: { () -> Void in
                self.getdata(titlename: self.linktitle)
                self.tableView.reloadData()
            });
        }
        task.resume()
    }
    
    
     func removeitem(id:Int) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/deleteitem_service.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(id)"
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            DispatchQueue.main.async(execute: { () -> Void in
                self.getdata(titlename: self.linktitle)
                self.tableView.reloadData()
            });
        }
        task.resume()
    }
}


