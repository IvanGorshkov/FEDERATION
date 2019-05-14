//
//  ViewController.swift
//  ФEDERATION
//
//  Created by Ivan Gorshkov on 30/04/2019.
//  Copyright © 2019 Ivan Gorshkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,DBModelProtocol,DBModelKapitalProtocol,DBModelInfoProtocol{
    
    var refreshController: UIRefreshControl?
    var isFilter = false
    var feedItems: NSArray = NSArray()
    var kapitalItems: NSArray = NSArray()
    var infoItems: NSArray = NSArray()
    var filterdata : [ItemsModel] = [ItemsModel()]
    var empty = 0
    @IBOutlet weak var collectionview: UICollectionView!
    func KapitalDownloaded(items: NSArray) {
        kapitalItems = items
    }
    func infoDownloaded(items: NSArray) {
        infoItems = items
        customActivityIndicatory(self.view, startAnimate: false)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        isFilter=true
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterdata=feedItems as! [ItemsModel]
        //print(filterdata)
        isFilter=false
        collectionview.reloadData()
         searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print(searchText)
        filterdata.removeAll()
        empty = 0
        searchBar.showsCancelButton = true
        for i in 0 ..< feedItems.count{
            let item: ItemsModel = feedItems[i] as! ItemsModel
            
            if(item.name?.lowercased().contains(searchText.lowercased()))!{
                empty+=1
                filterdata.append(feedItems[i] as! ItemsModel)
                //let items: ItemsModel = feedItems[i] as! ItemsModel
                //print(items.name ?? "")
                isFilter=true
                  collectionview.reloadData()
            }
            if empty == 0{
             
                            filterdata.removeAll()
                            isFilter=true
                            collectionview.reloadData()
                
            }
            if (searchText==""){
                filterdata=feedItems as! [ItemsModel]
                //print(filterdata)
                isFilter=false
                  collectionview.reloadData()
                return
            }
        
        
      
    }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  isFilter == true {
              return filterdata.count
        }
        return feedItems.count
    }
    
    @IBAction func Kapital(_ sender: Any) {
        var kapint = 0
        var countitems = 0
        for i in 0 ..< kapitalItems.count{
            let item: ItemsModel = kapitalItems[i] as! ItemsModel
            kapint=kapint+item.price!*Int(item.id!)!
            countitems=countitems+Int(item.id!)!
        }
        let info: InfoModel = infoItems[0] as! InfoModel
        
        let alertController = UIAlertController(title: "Информация", message: "Капитализация: \(kapint)₽ \n Количество вещей: \(countitems) \nПродано вещей: \( info.qogs ?? "0")\nПродано на: \( info.soldon ?? "0")₽ \nДоход: \(info.profit ?? "0")₽",  preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
            
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for:  indexPath) as? ItemCollectionViewCell {
            if isFilter == true{
                let item: ItemsModel = filterdata[indexPath.row]
                itemCell.menu =  item
                     //print("2")
            }
            else{
                //print("1")
                let item: ItemsModel = feedItems[indexPath.row] as! ItemsModel
                itemCell.menu =  item
            }
         
            itemCell.layer.cornerRadius = 15.0
            itemCell.layer.borderWidth = 1.0
            itemCell.layer.borderColor = UIColor (red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            return itemCell
        }
        
        return UICollectionViewCell()
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
       //print(feedItems)
        self.collectionview.reloadData()
        for i in 0 ..< feedItems.count{
            let item: ItemsModel = feedItems[i] as! ItemsModel
            print(item.name as Any)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customActivityIndicatory(self.view, startAnimate: true)
        let homeModel = DBModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        let kapModel = DBModelKapital()
        kapModel.delegate = self
        kapModel.downloadPrice()
        let infoModel = DBModelInfo()
        infoModel.delegate = self
        infoModel.downloadItems()
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
       
        searchBar.placeholder = "Поиск..."
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
    self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "ФEDERATION"
      
        addRefreshControll()
        // Do any additional setup after loading the view.
    }
    func addRefreshControll(){
        refreshController=UIRefreshControl()
        refreshController?.tintColor = UIColor .gray
        refreshController!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionview.refreshControl = refreshController
    }
    @objc func refresh(){
         DispatchQueue.global(qos: .background).async { [weak self] in
        let homeModel = DBModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        let kapModel = DBModelKapital()
        kapModel.delegate = self
        kapModel.downloadPrice()
        let infoModel = DBModelInfo()
        infoModel.delegate = self
        infoModel.downloadItems()
         DispatchQueue.main.async(execute: { () -> Void in
                
               self?.refreshController?.endRefreshing()
                //self?.collectionview.reloadData()
            })
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
                return
            }
        if isFilter == true{
            let item: ItemsModel = filterdata[indexPath.row] 
            destinationVC.linktitle = item.name ?? ""
        }
        else{
            let item: ItemsModel = feedItems[indexPath.row] as! ItemsModel
            destinationVC.linktitle = item.name ?? ""
        }
      
            navigationController?.pushViewController(destinationVC, animated: true)
        
    
}
    
    @IBAction func addItem(_ sender: Any) {
        let modal = AddItemViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
      
        modal.modalPresentationStyle = .custom
        modal.countid=feedItems.count
        self.present(modal, animated: true, completion: nil)
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width - 40, height: 218)
        
}
}
