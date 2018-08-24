//
//  myTripTableViewCell.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 22/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit


class myTripTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var pickImageViewMarker:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "pickUpRealMarker")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var dropOffImageViewMarker:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "dropOffMarker")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var pickUpAddressLabel:UILabel = {
        let label = UILabel()
        label.text = "This is the pick up address of the booking"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dropOffAddressLabel:UILabel = {
       let label = UILabel()
         label.text = "This is the drop Off address of the booking"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var staticMapImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "staticmap")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var priceLabel:UILabel = {
        let label = UILabel()
        label.text = "€ 19"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateAndTimeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.text = "Aug 19, Tuesday, 12:00 PM"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var driverNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        label.text = "James Citizen"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var carNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.text = "Mercedes Benz Black"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var driverImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "james")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    //MARK: View and AutoLayout setup
    
    func setupViews(){
        
        self.contentView.addSubview(pickImageViewMarker)
        self.contentView.addSubview(pickUpAddressLabel)
        self.contentView.addSubview(dropOffImageViewMarker)
        self.contentView.addSubview(dropOffAddressLabel)
        self.contentView.addSubview(staticMapImageView)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(dateAndTimeLabel)
        self.contentView.addSubview(driverNameLabel)
        self.contentView.addSubview(carNameLabel)
        self.contentView.addSubview(driverImageView)
        
        NSLayoutConstraint.activate([
            self.pickImageViewMarker.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 6),
            self.pickImageViewMarker.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6),
            self.pickImageViewMarker.widthAnchor.constraint(equalToConstant: 20),
            self.pickImageViewMarker.heightAnchor.constraint(equalToConstant: 20),
            
            self.pickUpAddressLabel.leftAnchor.constraint(equalTo: pickImageViewMarker.rightAnchor, constant: 10),
            self.pickUpAddressLabel.centerYAnchor.constraint(equalTo: pickImageViewMarker.centerYAnchor),
            self.pickUpAddressLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -6),
            self.pickUpAddressLabel.heightAnchor.constraint(equalToConstant: 25),
            
            self.dropOffImageViewMarker.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 6),
            self.dropOffImageViewMarker.topAnchor.constraint(equalTo: pickUpAddressLabel.bottomAnchor, constant: 4),
            self.dropOffImageViewMarker.widthAnchor.constraint(equalToConstant: 20),
            self.dropOffImageViewMarker.heightAnchor.constraint(equalToConstant: 20),
            
            self.dropOffAddressLabel.leftAnchor.constraint(equalTo: dropOffImageViewMarker.rightAnchor, constant: 10),
            self.dropOffAddressLabel.centerYAnchor.constraint(equalTo: dropOffImageViewMarker.centerYAnchor),
            self.dropOffAddressLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -6),
            self.dropOffAddressLabel.heightAnchor.constraint(equalToConstant: 25),
            
            self.staticMapImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.staticMapImageView.topAnchor.constraint(equalTo: dropOffAddressLabel.bottomAnchor),
            self.staticMapImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            self.staticMapImageView.heightAnchor.constraint(equalToConstant: 180),
            
            self.driverImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -6),
            self.driverImageView.topAnchor.constraint(equalTo: staticMapImageView.bottomAnchor, constant: 0),
            self.driverImageView.widthAnchor.constraint(equalToConstant: 50),
            self.driverImageView.heightAnchor.constraint(equalToConstant: 50),
            
            self.driverNameLabel.rightAnchor.constraint(equalTo: driverImageView.leftAnchor, constant: -6),
            self.driverNameLabel.topAnchor.constraint(equalTo: driverImageView.topAnchor),
            self.driverNameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            self.driverNameLabel.heightAnchor.constraint(equalTo: driverImageView.heightAnchor, multiplier: 0.5),
            
            self.carNameLabel.bottomAnchor.constraint(equalTo: driverImageView.bottomAnchor),
            self.carNameLabel.rightAnchor.constraint(equalTo: driverImageView.leftAnchor, constant: -6),
            self.carNameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            self.carNameLabel.heightAnchor.constraint(equalTo: driverImageView.heightAnchor, multiplier: 0.5),
            
            
            self.priceLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 6),
            self.priceLabel.topAnchor.constraint(equalTo: self.staticMapImageView.bottomAnchor, constant: 0),
            self.priceLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            self.priceLabel.heightAnchor.constraint(equalTo: driverImageView.heightAnchor, multiplier: 0.5),
            
            self.dateAndTimeLabel.leftAnchor.constraint(equalTo: priceLabel.leftAnchor),
            self.dateAndTimeLabel.bottomAnchor.constraint(equalTo: driverImageView.bottomAnchor),
            self.dateAndTimeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            self.dateAndTimeLabel.heightAnchor.constraint(equalTo: driverImageView.heightAnchor, multiplier: 0.5)
            
            ])
        
        
    }
    
    
    //MARK:-  Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
