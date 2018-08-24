//
//  AccountViewController.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 12/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    var tableHeaderView:UIView = {
       let headerView = UIView()
        headerView.backgroundColor = .white
        return headerView
    }()
    
    var tableFooterView:UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .white
        return footerView
    }()

    
    var profileImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "userProfile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Shrikant Chidgopkar"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var seperatorLineViewAfterNameLabel:UIView = {
        let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var favouriteDriversButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Favourite Drivers", for: .normal)
        button.setImage(#imageLiteral(resourceName: "starEmpty").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var seperatorLineView:UIView = {
        let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var myTripsButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("My Trips", for: .normal)
        button.setImage(#imageLiteral(resourceName: "trips").withRenderingMode(.alwaysTemplate), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.tintColor = .black
        button.addTarget(self, action: #selector(myTripsButtonPressed), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var logOutButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    //MARK:Actions
    
    
    @objc func myTripsButtonPressed(){
        
        let myTripsViewController = MyTripsViewController()
        
        self.navigationController?.pushViewController(myTripsViewController, animated: true)
        
    }
    
    
    //MARK: UITableView Delegate and Datasource

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeaderView = UIView()
        
        sectionHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20)
        
        sectionHeaderView.backgroundColor = UIColor.groupTableViewBackground
        
        return sectionHeaderView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 3
        default:
            break
        }
        
        return 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        
        cell.accessoryType = .disclosureIndicator
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0{
            
            if indexPath.row == 0{
                cell.textLabel?.text = "Wallet"
                cell.imageView?.image = #imageLiteral(resourceName: "wallet")
            }
            if indexPath.row == 1{
                cell.textLabel?.text = "Add Promo Code"
                cell.imageView?.image = #imageLiteral(resourceName: "promo")
            }
        }
        
        if indexPath.section == 1{
            if indexPath.row == 0{
                cell.textLabel?.text = "Fare Estimate"
                cell.imageView?.image = #imageLiteral(resourceName: "estimate")
            }
        }
        
        if indexPath.section == 2{
            if indexPath.row == 0 {
                cell.textLabel?.text = "Help and Contact"
                cell.imageView?.image = #imageLiteral(resourceName: "help")
            }
            if indexPath.row == 1{
                cell.textLabel?.text = "Privacy Settings"
                cell.imageView?.image = #imageLiteral(resourceName: "privacy")
            }
            if indexPath.row == 2{
                cell.textLabel?.text = "Legal"
                cell.imageView?.image = #imageLiteral(resourceName: "legal")
            }
        }
        return cell
        
    }
    
    
    //MARK: TableView setup
    
    func setupTableView(){
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView
    }
    
    
    func setupTableHeaderView(){
        
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 220)
        
        tableHeaderView.addSubview(profileImageView)
        tableHeaderView.addSubview(nameLabel)
        tableHeaderView.addSubview(seperatorLineViewAfterNameLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: self.tableHeaderView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: self.tableHeaderView.topAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.centerXAnchor.constraint(equalTo: tableHeaderView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            nameLabel.widthAnchor.constraint(equalTo: tableHeaderView.widthAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            seperatorLineViewAfterNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            seperatorLineViewAfterNameLabel.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor),
            seperatorLineViewAfterNameLabel.widthAnchor.constraint(equalTo: tableHeaderView.widthAnchor),
            seperatorLineViewAfterNameLabel.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(favouriteDriversButton)
        stackView.addArrangedSubview(myTripsButton)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 1
        
        tableHeaderView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor),
            stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            stackView.topAnchor.constraint(equalTo: seperatorLineViewAfterNameLabel.bottomAnchor)
            ])
        
        stackView.addSubview(seperatorLineView)
        
        NSLayoutConstraint.activate([
            seperatorLineView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            seperatorLineView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            seperatorLineView.widthAnchor.constraint(equalToConstant: 1),
            seperatorLineView.heightAnchor.constraint(equalTo: stackView.heightAnchor)
            ])
        
        favouriteDriversButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        favouriteDriversButton.imageView?.leftAnchor.constraint(equalTo: favouriteDriversButton.leftAnchor, constant:8).isActive = true
        favouriteDriversButton.imageView?.centerYAnchor.constraint(equalTo: favouriteDriversButton.centerYAnchor).isActive = true
        
        myTripsButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        myTripsButton.imageView?.leftAnchor.constraint(equalTo: myTripsButton.leftAnchor, constant:8).isActive = true
        myTripsButton.imageView?.centerYAnchor.constraint(equalTo: myTripsButton.centerYAnchor).isActive = true
        
        
    }
    
    
    func setUpTableFooterView(){
        
        tableFooterView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        tableFooterView.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.centerYAnchor.constraint(equalTo: tableFooterView.centerYAnchor),
            logOutButton.centerXAnchor.constraint(equalTo: tableFooterView.centerXAnchor),
            logOutButton.widthAnchor.constraint(equalTo: tableFooterView.widthAnchor),
            logOutButton.heightAnchor.constraint(equalTo: tableFooterView.heightAnchor)
            ])
        
    }
    
    
    //MARK: View loaded
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableHeaderView()
        self.setupTableView()
        self.setUpTableFooterView()
        
        self.navigationItem.title = "My Account"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor]

        let backItem = UIBarButtonItem()
        backItem.title = "back"
        
        self.navigationItem.backBarButtonItem = backItem
        
        self.view.backgroundColor = .white
        

        
    }
    
}
