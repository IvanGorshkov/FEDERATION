//
//  AddItemViewController.swift
//  FEDERATION
//
//  Created by Ivan Gorshkov on 02/05/2019.
//  Copyright © 2019 Ivan Gorshkov. All rights reserved.
//

import UIKit
class AddItemViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    @IBOutlet var saveBuuton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textFieldTitle: UITextField!
    @IBOutlet var textFieldColor: UITextField!
    @IBOutlet var textFieldSize: UITextField!
    @IBOutlet var textFieldPrice: UITextField!
    @IBOutlet var textFieldQual: UITextField!
    var countid = 0
    var tmpimage:UIImage?
    var nameImage:String? = ""
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
    @objc fileprivate func keyboardWillShow(notification:NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRectValue.height
            
            scrollView.contentSize = CGSize(width: self.view.frame.width,height: saveBuuton.frame.origin.y+saveBuuton.frame.height+keyboardHeight)
        }
     //   scrollView.isScrollEnabled=true
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //scrollView.isScrollEnabled=false
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @IBAction func SaveClicked() {
        if textFieldQual.text != "",textFieldSize.text != "",textFieldColor.text != "",textFieldPrice.text != "",textFieldTitle.text != "", tmpimage != nil {
        var request = NSMutableURLRequest(url: NSURL(string: "http://db.dragonmaster.ru/saveitem_service.php")! as URL)
        request.httpMethod = "POST"
        let nameImage = randomStringWithLength(len: 10)
        
        let postString = "a=\(countid)&b=\(nameImage).jpg&c=\( textFieldTitle.text!)&d=\( textFieldSize.text!)&e=\( textFieldColor.text!)&f=\( textFieldPrice.text!)&g=\( textFieldQual.text!)"
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        var task = URLSession.shared.dataTask(with: request as URLRequest) {
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
        
        let myUrl = NSURL(string: "http://db.dragonmaster.ru/uploadimg.php");
        
         request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = tmpimage!.jpegData(compressionQuality: 0.5)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: ["firstName":"Ivan"], filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary, imgName: nameImage as String) as Data
        
        //myActivityIndicator.startAnimating();
        
        task =  URLSession.shared.dataTask(with: request as URLRequest,
                                               completionHandler: {
                                                (data, response, error) -> Void in
                                                if let data = data {
                                                    
                                                    // You can print out response object
                                                    print("******* response = \(String(describing: response))")
                                                    
                                                    print(data.count)
                                                    // you can use data here
                                                    
                                                    // Print out reponse body
                                                    let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                                    print("****** response data = \(responseString!)")
                                                    
                                                    let json =  try!JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                                                    
                                                    print("json value \(String(describing: json))")
                                                    
                                                    //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
                                                    
                                                    
                                                    
                                                } else if error != nil {
                                                    
                                                }
                                                 self.dismiss()
        })
        task.resume()
        
        
    }
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, imgName:String?) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        let filename = "\(imgName ?? "").jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
   

    @IBAction func btnClicked() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Добавить фотографию", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Камера", style:  .default, handler:{ (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
              self.present(imagePickerController, animated: true, completion: nil)
        } ))
        actionSheet.addAction(UIAlertAction(title: "Галерея", style:  .default, handler:{ (action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        } ))
        actionSheet.addAction(UIAlertAction(title: "Отмена", style:  .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        // Use editedImage Here
        tmpimage = editedImage
        imageView.image = editedImage
    }
    
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
private extension Selector {
    static let keyboardWillShow = #selector(AddItemViewController.keyboardWillShow(notification:))
}
