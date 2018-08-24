//
//  PreferencesCollectionView.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 09/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit

class PreferencesCollectionView: UIView, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties
    
    let preferencesCellReuseIdentifier = "cellID"
    
    var homeViewController:HomeViewController?
    
    var preferences = ["Message Driver","Favourite Drivers", "Mercedes-Benz Taxi","5 Star Drivers", "Small Pet", "Courier Trip", "Eco-Taxi", "Multi-Seater"]
    
    var preferencesPhotos = [#imageLiteral(resourceName: "message"),#imageLiteral(resourceName: "driver"),#imageLiteral(resourceName: "mercedes"),#imageLiteral(resourceName: "star"),#imageLiteral(resourceName: "pet"),#imageLiteral(resourceName: "package"),#imageLiteral(resourceName: "eco"),#imageLiteral(resourceName: "suv")]
    
    lazy var preferencesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    //MARK: - Setup CollectionView
    
    func setUpCollectionView(){
        
        if let flowLayout = preferencesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        addSubview(preferencesCollectionView)
        
        preferencesCollectionView.register(PreferenceCell.self, forCellWithReuseIdentifier: preferencesCellReuseIdentifier)
        
        NSLayoutConstraint.activate([
            preferencesCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            preferencesCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            preferencesCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            preferencesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
            ])
        
        preferencesCollectionView.showsHorizontalScrollIndicator = false
        preferencesCollectionView.allowsMultipleSelection = true
    }
    
    //MARK: - CollectionView Delegate and Datasource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preferences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = preferencesCollectionView.dequeueReusableCell(withReuseIdentifier: preferencesCellReuseIdentifier, for: indexPath)  as! PreferenceCell
        
        cell.preferenceImageView.image = preferencesPhotos[indexPath.item].withRenderingMode(.alwaysTemplate)
        cell.preferenceName.text = preferences[indexPath.item]
        
        cell.layer.cornerRadius = cell.frame.size.width / 2
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0{
            self.homeViewController?.messageDriverCellPressed()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 60, height: 60)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    //MARK: - Init 
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


