//
//  MyTripsViewController.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 22/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit


class MyTripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    private let cellID = "cellID"
    
    let yellowMyTaxiColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
    
    lazy var tableView:UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    //MARK: TableView Delegate and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? myTripTableViewCell
        
        cell?.driverImageView.layoutIfNeeded()
        cell?.driverImageView.layer.cornerRadius = (cell?.driverImageView.frame.height)! / 2
        cell?.driverImageView.layer.masksToBounds = true
        cell?.pickUpAddressLabel.text = "Norderreihe 3, 22767 Hamburg, Germany"
        cell?.dropOffAddressLabel.text = "Bahnsteig Gleis 1 + 2, 20099 Hamburg, Germany"
        
        return cell!
        
    }
    
    
    //MARK: TableView Setup
    
    func setUpTableView(){
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        tableView.rowHeight = 290
        tableView.estimatedRowHeight = 290
        
        tableView.register(myTripTableViewCell.self, forCellReuseIdentifier: cellID)
    
    }
    
    
    func setupNavBar(){
        
        self.title = "My Trips"
        self.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setUpTableView()
        
    }
    
}
