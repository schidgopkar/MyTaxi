//
//  DriverAndRideDetailsView.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 19/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit


class DriverAndRideDetailsView: UIView {
    
    
    //MARK: - Properties
    
    var driverImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "james")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var driverNameLabel:UILabel = {
       let label = UILabel()
        label.text = "James Citizen"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var driverRatingLabel:UILabel = {
        let label = UILabel()
        label.text = "4.9 ⭑"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var carNameLabel:UILabel = {
        let label = UILabel()
        label.text = "Black Mercedes-Benz"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var carNumberPlateLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let driverDetailsContainerView = UIView()
    
    let carDetailsContainerView = UIView()
    
    var carNumberPlateWidthConstraint:NSLayoutConstraint?
    
    var seperatorLineView:UIView = {
        let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var callDriverButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cancelRideButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var messageDriverButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var moreButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var seperatorLineNumber1BetweenButtons:UIView = {
        let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var seperatorLineNumber2BetweenButtons:UIView = {
        let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var seperatorLineNumber3BetweenButtons:UIView = {
        let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    var priceLabel:UILabel = {
       let label = UILabel()
        label.text = "€ 15 - 18"
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seperatorLineViewAfterButtons:UIView = {
        let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    func setupViews(){
        
        driverDetailsContainerView.translatesAutoresizingMaskIntoConstraints = false
        carDetailsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        driverDetailsContainerView.addSubview(driverImageView)
        driverDetailsContainerView.addSubview(driverNameLabel)
        driverDetailsContainerView.addSubview(driverRatingLabel)
        
        carDetailsContainerView.addSubview(carNameLabel)
        carDetailsContainerView.addSubview(carNumberPlateLabel)
        
        NSLayoutConstraint.activate([
            
            self.driverImageView.leftAnchor.constraint(equalTo: driverDetailsContainerView.leftAnchor, constant: 8),
            self.driverImageView.topAnchor.constraint(equalTo: driverDetailsContainerView.topAnchor, constant: 8),
            self.driverImageView.widthAnchor.constraint(equalToConstant: 70),
            self.driverImageView.heightAnchor.constraint(equalToConstant: 70),
            
            self.driverNameLabel.topAnchor.constraint(equalTo: driverImageView.topAnchor, constant:5),
            self.driverNameLabel.leftAnchor.constraint(equalTo: driverImageView.rightAnchor, constant: 10),
            self.driverNameLabel.rightAnchor.constraint(equalTo: driverDetailsContainerView.rightAnchor, constant: -4),
            self.driverNameLabel.heightAnchor.constraint(equalTo: driverImageView.heightAnchor, multiplier: 0.3),
            
            self.driverRatingLabel.leftAnchor.constraint(equalTo: driverNameLabel.leftAnchor),
            self.driverRatingLabel.rightAnchor.constraint(equalTo: driverNameLabel.rightAnchor),
            self.driverRatingLabel.bottomAnchor.constraint(equalTo: driverImageView.bottomAnchor),
            self.driverRatingLabel.heightAnchor.constraint(equalTo: driverImageView.heightAnchor, multiplier: 0.7, constant: -5)
            
        ])
        

        
        // keep the width of carNumberPlate to zero initially and change it at runtime to match the width of the text
        
        carNumberPlateWidthConstraint = self.carNumberPlateLabel.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            self.carNameLabel.rightAnchor.constraint(equalTo: carDetailsContainerView.rightAnchor, constant: -8),
            self.carNameLabel.topAnchor.constraint(equalTo: carDetailsContainerView.topAnchor, constant: 13),
            self.carNameLabel.leftAnchor.constraint(equalTo: carDetailsContainerView.leftAnchor, constant: 8),
            self.carNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            self.carNumberPlateLabel.rightAnchor.constraint(equalTo: carNameLabel.rightAnchor),
            self.carNumberPlateLabel.topAnchor.constraint(equalTo: carNameLabel.bottomAnchor, constant: 5),
            carNumberPlateWidthConstraint!,
            self.carNumberPlateLabel.heightAnchor.constraint(equalToConstant: 35)
            ])
        
        // create a new stackView and add 'carDetailsContainerView' and 'driverDetailsContainer' as arranged Subviews
        
        let driverAndCarDetailsStackView = UIStackView()
        
        driverAndCarDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(driverAndCarDetailsStackView)
        
        NSLayoutConstraint.activate([
            driverAndCarDetailsStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            driverAndCarDetailsStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            driverAndCarDetailsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            driverAndCarDetailsStackView.heightAnchor.constraint(equalToConstant: 80)
            ])
        
        
        driverAndCarDetailsStackView.addArrangedSubview(driverDetailsContainerView)
        driverAndCarDetailsStackView.addArrangedSubview(carDetailsContainerView)
        
        driverAndCarDetailsStackView.axis = .horizontal
        driverAndCarDetailsStackView.distribution = .fillEqually
        
        self.addSubview(seperatorLineView)
        
        NSLayoutConstraint.activate([
            self.seperatorLineView.topAnchor.constraint(equalTo: driverAndCarDetailsStackView.bottomAnchor, constant: 0),
            self.seperatorLineView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.seperatorLineView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.seperatorLineView.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        
        // MARK: - Call Button Set up
        
        
        let callButtonContainerView = UIView()
        callButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let callLabel = UILabel()
        callLabel.font = UIFont.systemFont(ofSize: 10)
        callLabel.text = "Call Driver"
        callLabel.textAlignment = .center
        callLabel.translatesAutoresizingMaskIntoConstraints = false
        
        callButtonContainerView.addSubview(callDriverButton)
        callButtonContainerView.addSubview(callLabel)
        callButtonContainerView.addSubview(seperatorLineNumber1BetweenButtons)
        
        NSLayoutConstraint.activate([
            callDriverButton.centerXAnchor.constraint(equalTo: callButtonContainerView.centerXAnchor),
            callDriverButton.topAnchor.constraint(equalTo: callButtonContainerView.topAnchor, constant: 4),
            callDriverButton.widthAnchor.constraint(equalToConstant: 25),
            callDriverButton.heightAnchor.constraint(equalToConstant: 25),
            
            callLabel.topAnchor.constraint(equalTo: callDriverButton.bottomAnchor, constant: 5),
            callLabel.centerXAnchor.constraint(equalTo: callButtonContainerView.centerXAnchor),
            callLabel.widthAnchor.constraint(equalTo: callButtonContainerView.widthAnchor),
            callLabel.heightAnchor.constraint(equalToConstant: 15),
            
            seperatorLineNumber1BetweenButtons.rightAnchor.constraint(equalTo: callButtonContainerView.rightAnchor),
            seperatorLineNumber1BetweenButtons.topAnchor.constraint(equalTo: callButtonContainerView.topAnchor),
            seperatorLineNumber1BetweenButtons.widthAnchor.constraint(equalToConstant: 1),
            seperatorLineNumber1BetweenButtons.heightAnchor.constraint(equalTo: callButtonContainerView.heightAnchor)
            
            ])
        
        
        //MARK: - Message Driver Button Setup
        
        let messageDriverButtonConatinerView = UIView()
        messageDriverButtonConatinerView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageDriverLabel = UILabel()
        messageDriverLabel.font = UIFont.systemFont(ofSize: 10)
        messageDriverLabel.text = "Message Driver"
        messageDriverLabel.textAlignment = .center
        messageDriverLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageDriverButtonConatinerView.addSubview(messageDriverButton)
        messageDriverButtonConatinerView.addSubview(messageDriverLabel)
        messageDriverButtonConatinerView.addSubview(seperatorLineNumber2BetweenButtons)
        
        NSLayoutConstraint.activate([
            messageDriverButton.centerXAnchor.constraint(equalTo: messageDriverButtonConatinerView.centerXAnchor),
            messageDriverButton.topAnchor.constraint(equalTo: messageDriverButtonConatinerView.topAnchor, constant:4),
            messageDriverButton.widthAnchor.constraint(equalToConstant: 25),
            messageDriverButton.heightAnchor.constraint(equalToConstant: 25),
            
            messageDriverLabel.topAnchor.constraint(equalTo: messageDriverButton.bottomAnchor, constant: 5),
            messageDriverLabel.centerXAnchor.constraint(equalTo: messageDriverButtonConatinerView.centerXAnchor),
            messageDriverLabel.widthAnchor.constraint(equalTo: messageDriverButtonConatinerView.widthAnchor),
            messageDriverLabel.heightAnchor.constraint(equalToConstant: 15),
            
            seperatorLineNumber2BetweenButtons.rightAnchor.constraint(equalTo: messageDriverButtonConatinerView.rightAnchor),
            seperatorLineNumber2BetweenButtons.topAnchor.constraint(equalTo: messageDriverButtonConatinerView.topAnchor),
            seperatorLineNumber2BetweenButtons.widthAnchor.constraint(equalToConstant: 1),
            seperatorLineNumber2BetweenButtons.heightAnchor.constraint(equalTo: messageDriverButtonConatinerView.heightAnchor)
            
            ])
        
        
        
        //MARK: - cancel Button Setup
        
        let cancelButtonConatinerView = UIView()
        cancelButtonConatinerView.translatesAutoresizingMaskIntoConstraints = false
        
        let cancelRideLabel = UILabel()
        cancelRideLabel.font = UIFont.systemFont(ofSize: 10)
        cancelRideLabel.text = "Cancel Ride"
        cancelRideLabel.textAlignment = .center
        cancelRideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButtonConatinerView.addSubview(cancelRideButton)
        cancelButtonConatinerView.addSubview(cancelRideLabel)
        cancelButtonConatinerView.addSubview(seperatorLineNumber3BetweenButtons)
        
        NSLayoutConstraint.activate([
            cancelRideButton.centerXAnchor.constraint(equalTo: cancelButtonConatinerView.centerXAnchor),
            cancelRideButton.topAnchor.constraint(equalTo: cancelButtonConatinerView.topAnchor, constant:4),
            cancelRideButton.widthAnchor.constraint(equalToConstant: 25),
            cancelRideButton.heightAnchor.constraint(equalToConstant: 25),
            
            cancelRideLabel.topAnchor.constraint(equalTo: cancelRideButton.bottomAnchor, constant: 5),
            cancelRideLabel.centerXAnchor.constraint(equalTo: cancelButtonConatinerView.centerXAnchor),
            cancelRideLabel.widthAnchor.constraint(equalTo: cancelButtonConatinerView.widthAnchor),
            cancelRideLabel.heightAnchor.constraint(equalToConstant: 15),
            
            seperatorLineNumber3BetweenButtons.rightAnchor.constraint(equalTo: cancelButtonConatinerView.rightAnchor),
            seperatorLineNumber3BetweenButtons.topAnchor.constraint(equalTo: cancelButtonConatinerView.topAnchor),
            seperatorLineNumber3BetweenButtons.widthAnchor.constraint(equalToConstant: 1),
            seperatorLineNumber3BetweenButtons.heightAnchor.constraint(equalTo: cancelButtonConatinerView.heightAnchor)
            ])
        
        
        //MARK: - more button set up
        
        let moreButtonContainerView = UIView()
        moreButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let moreLabel = UILabel()
        moreLabel.font = UIFont.systemFont(ofSize: 10)
        moreLabel.text = "More"
        moreLabel.textAlignment = .center
        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        moreButtonContainerView.addSubview(moreButton)
        moreButtonContainerView.addSubview(moreLabel)
        
        NSLayoutConstraint.activate([
            moreButton.centerXAnchor.constraint(equalTo: moreButtonContainerView.centerXAnchor),
            moreButton.topAnchor.constraint(equalTo: moreButtonContainerView.topAnchor, constant:4),
            moreButton.widthAnchor.constraint(equalToConstant: 25),
            moreButton.heightAnchor.constraint(equalToConstant: 25),
            
            moreLabel.topAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: 5),
            moreLabel.centerXAnchor.constraint(equalTo: moreButtonContainerView.centerXAnchor),
            moreLabel.widthAnchor.constraint(equalTo: moreButtonContainerView.widthAnchor),
            moreLabel.heightAnchor.constraint(equalToConstant: 15),

            ])

        
        //MARK: - ButtonsStackView Setup
        
        // add 'call Driver','message driver', 'cancel ride' and 'more' containerviews to a horizontal stackview
        
        let buttonsStackView = UIStackView()
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: seperatorLineView.bottomAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 1
        
        
        buttonsStackView.addArrangedSubview(callButtonContainerView)
        buttonsStackView.addArrangedSubview(messageDriverButtonConatinerView)
        buttonsStackView.addArrangedSubview(cancelButtonConatinerView)
        buttonsStackView.addArrangedSubview(moreButtonContainerView)
        
        
        //MARK: - Price setup
        
        let label = UILabel()
        label.text = "Estimated cash to be paid:"
        label.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(seperatorLineViewAfterButtons)
        self.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            seperatorLineViewAfterButtons.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            seperatorLineViewAfterButtons.leftAnchor.constraint(equalTo: self.leftAnchor),
            seperatorLineViewAfterButtons.widthAnchor.constraint(equalTo: self.widthAnchor),
            seperatorLineViewAfterButtons.heightAnchor.constraint(equalToConstant: 1),
            
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: seperatorLineViewAfterButtons.bottomAnchor, constant: 4),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            label.heightAnchor.constraint(equalToConstant: 30),
            
            priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            priceLabel.topAnchor.constraint(equalTo: label.topAnchor),
            priceLabel.leftAnchor.constraint(equalTo: label.leftAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        
    }
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
