//
//  TriangularInfoView.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 15/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit


class MarkerInfoView: UIView {
    
    var timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    func setUpView(){
        
        self.addSubview(timeLabel)
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant:15),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            timeLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        self.alpha = 0.8
        self.layer.cornerRadius = 8
        
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
