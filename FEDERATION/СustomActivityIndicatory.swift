//
//  File.swift
//  Moscowich
//
//  Created by Ivan Gorshkov on 24/04/2019.
//  Copyright © 2019 goldmanspirit. All rights reserved.
//

import Foundation
import UIKit

@discardableResult
func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
    let mainContainer: UIView = UIView(frame: viewContainer.frame)
    mainContainer.center = viewContainer.center
    mainContainer.backgroundColor = UIColor.white
    mainContainer.alpha = 0.5
    mainContainer.tag = 789456123
    mainContainer.isUserInteractionEnabled = false
    
    let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 100,height: 100))
    viewBackgroundLoading.center = viewContainer.center
    viewBackgroundLoading.backgroundColor = UIColor.darkGray
    viewBackgroundLoading.alpha = 0.5
    viewBackgroundLoading.clipsToBounds = true
    viewBackgroundLoading.layer.cornerRadius = 15
    
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
    activityIndicatorView.style =
        UIActivityIndicatorView.Style.whiteLarge
    activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
    let labeldownloading:UILabel = UILabel()
    //labeldownloading.frame = CGRect(x:0.0,y: 0.0,width: 80, height: 20)
    labeldownloading.text = "Загрузка"
    labeldownloading.textColor = UIColor .white
    labeldownloading.textAlignment = NSTextAlignment.center
   // labeldownloading.center = activityIndicatorView.center
    labeldownloading.frame = CGRect(x: 0, y:70, width: 100, height: 20)
    if startAnimate!{
        viewBackgroundLoading.addSubview(labeldownloading)
        viewBackgroundLoading.addSubview(activityIndicatorView)
        mainContainer.addSubview(viewBackgroundLoading)
        viewContainer.addSubview(mainContainer)
        activityIndicatorView.startAnimating()
    }else{
        for subview in viewContainer.subviews{
            if subview.tag == 789456123{
                subview.removeFromSuperview()
            }
        }
    }
    return activityIndicatorView
}
