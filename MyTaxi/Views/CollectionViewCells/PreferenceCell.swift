//
//  PreferencesCollectionViewCell.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 23/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit


class PreferenceCell:UICollectionViewCell{
    
    //MARK: Properties
    
    var preferenceImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var preferenceName:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 9)
        label.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK:-  View and AUtoLayout Setup
    
    func setUpViews(){
        
        addSubview(preferenceImageView)
        addSubview(preferenceName)
        
        NSLayoutConstraint.activate([
            preferenceImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            preferenceImageView.topAnchor.constraint(equalTo: self.topAnchor, constant:4),
            preferenceImageView.widthAnchor.constraint(equalToConstant: 20),
            preferenceImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            preferenceName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            preferenceName.topAnchor.constraint(equalTo: preferenceImageView.bottomAnchor, constant: 2),
            preferenceName.widthAnchor.constraint(equalToConstant: self.frame.width - 8),
            preferenceName.heightAnchor.constraint(equalToConstant: 22)
            ])
        
    }
    
    //MARK: - UICollectionViewCell Overrides
    
    override var isHighlighted: Bool{
        didSet {
            preferenceImageView.tintColor = isHighlighted ? UIColor.white : UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
            preferenceName.textColor = isHighlighted ? UIColor.white : UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
            self.backgroundColor = isHighlighted ? UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1) : .white
            self.layer.borderColor = isHighlighted ? UIColor.white.cgColor : UIColor.clear.cgColor
        }
    }
    
    override var isSelected: Bool{
        didSet{
            preferenceImageView.tintColor = isSelected ? UIColor.white : UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
            preferenceName.textColor = isSelected ? UIColor.white : UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
            self.backgroundColor = isSelected ? UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1) : .white
            self.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
        }
    }
    
    //MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
