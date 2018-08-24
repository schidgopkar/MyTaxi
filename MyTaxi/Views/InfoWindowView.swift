//
//  MarkerInfoWindowView.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 18/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit


class InfoWindowView: UIView {
    
    let grayMyTaxiColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    
    var radius: CGFloat = 11 { didSet { updateMask() } }
    
    var myTaxiLogoImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "myTaxiLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var timeRemainingLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.text = "15 mins"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupViews(){
        
        self.addSubview(myTaxiLogoImageView)
        self.addSubview(timeRemainingLabel)
        
        NSLayoutConstraint.activate([
            myTaxiLogoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            myTaxiLogoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            myTaxiLogoImageView.widthAnchor.constraint(equalToConstant: 20),
            myTaxiLogoImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            timeRemainingLabel.leftAnchor.constraint(equalTo: myTaxiLogoImageView.rightAnchor, constant: 10),
            timeRemainingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6),
            timeRemainingLabel.centerYAnchor.constraint(equalTo: myTaxiLogoImageView.centerYAnchor),
            timeRemainingLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        
    }
    
    // Cuts a half circle at the bottom of map marker's Info window
    
    private func updateMask() {
        let path = UIBezierPath()
        let center = CGPoint(x: bounds.origin.x + bounds.size.width / 2.0, y: bounds.origin.y + bounds.size.height)
        path.move(to: bounds.origin)
        path.addLine(to: CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y))
        path.addLine(to: CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height))
        path.addLine(to: CGPoint(x: bounds.origin.x + bounds.size.width / 2.0 + radius , y: bounds.origin.y + bounds.size.height))
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi, clockwise: false)
        path.addLine(to: CGPoint(x: bounds.origin.x + bounds.size.width / 2.0 - radius , y: bounds.origin.y + bounds.size.height))
        path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height))
        path.addLine(to: bounds.origin)
        
        path.close()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        
        self.setupViews()
        self.backgroundColor = grayMyTaxiColor
        self.bringSubview(toFront: myTaxiLogoImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
