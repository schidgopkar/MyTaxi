//
//  Extensions.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 21/07/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit
import GoogleMaps


extension UIViewController{
    

    func reverseGeocodeAddress(latitude:String,longitude:String,withCompletionHandler completionHandler: @escaping ((_ formattedAddress: String,_ success: Bool) -> Void)){
        
           let apiKey = "AIzaSyDVvArWNDNF-uNb5CuKLX-Eglha60yrwJo"
        
        let urlString =  "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                print("Google GEOCODEING ERROR IS",error)
                completionHandler("\(error)",false)
                return
            }
            
            do{
                if let unwrappedData = data, let json = try JSONSerialization.jsonObject(with:unwrappedData, options:JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                    
                    guard
                    let status = json["status"] as? String
                    else {
                        completionHandler("\(String(describing: error))",false)
                        return
                    }
                                        
                    if status == "OK" {
                        guard
                        let results = json["results"] as? [[String:Any]],
                        let formattedAddress = results[0]["formatted_address"] as? String
                        else {
                            completionHandler("\(String(describing: error))",false)
                            return
                        }
                        completionHandler(formattedAddress,true)
                    }
                }
            }catch let error as NSError {
                print(error)
                completionHandler("\(error)",false)
            }
            }.resume()
    }
    
        
    func drawCircleWith(radius:CGFloat,fillColor:UIColor,strokeColor:UIColor, lineWidth:CGFloat, inView:UIView, arcCenter:CGPoint) -> CAShapeLayer{
        
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = fillColor.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = strokeColor.cgColor
        //you can change the line width
        shapeLayer.lineWidth = lineWidth
        
        inView.layer.addSublayer(shapeLayer)
        
        return shapeLayer
        
    }
    
    
    func showAlertControllerwith(title:String, message: String, actionName: String, action:@escaping () -> Void){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let Okaction = UIAlertAction(title: actionName, style: .default) { (ac) in
            action()
        }
        
        alertController.addAction(Okaction)
        
        alertController.view.tintColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)

        
        self.present(alertController, animated: true, completion: nil)
        
    }


    
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


extension UIButton {
    
    func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
    
}



