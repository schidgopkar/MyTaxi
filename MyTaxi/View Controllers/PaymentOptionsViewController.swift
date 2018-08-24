//
//  AddPaymentViewController.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 13/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit

protocol PaymentOptionsDelegate {
    func getSelectedPaymentOption(selectedPaymentOption:PaymentOptions)
}

class PaymentOptionsViewController:UIViewController,UITableViewDelegate,UITableViewDataSource, AddPaymentMethodDelegate{
    
    //MARK: - Properties
    
    var delegate:PaymentOptionsDelegate?
    
    var selectedPaymentOption:PaymentOptions?
    
    private let cellID = "cellID"
    
    let yellowMyTaxiColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
    
    let cash = PaymentOptions.init(paymentTypeName: "Cash", paymentTypeImage: #imageLiteral(resourceName: "cash"))
    let payPal = PaymentOptions.init(paymentTypeName: "shri.c@hotmail.com", paymentTypeImage: #imageLiteral(resourceName: "paypal"))
    
    lazy var paymentOptions = [cash,payPal]
    
    //MARK: - View Properties
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: Protocol Method
    
    func paymentMethodWasAdded(paymentOption: PaymentOptions) {
        
        self.paymentOptions.append(paymentOption)
    }
    
    
    //MARK: - Actions
    
    @objc func addPaymentMethodButtonPressed(){
        
        let addPaymentViewController = AddPaymentMethodViewController()
        
        addPaymentViewController.delegate = self
        
        let backButtonItem = UIBarButtonItem()
        
        backButtonItem.title = "back"
        
        navigationItem.backBarButtonItem = backButtonItem
        
        self.navigationController?.pushViewController(addPaymentViewController, animated: true)
        
    }
    
    
    //MARK: TableView Setup
    
    func setUpTableView(){
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        tableView.sectionHeaderHeight = 50
        
        tableView.sectionFooterHeight = 50
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.tableFooterView = UIView()
    }
    
    
    //MARK: - TableView Delegate and Datasource
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionheaderView = UIView()
        sectionheaderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        sectionheaderView.backgroundColor = UIColor.groupTableViewBackground
        let labelForSectionHeader = UILabel()
        labelForSectionHeader.font = UIFont.systemFont(ofSize: 14)
        labelForSectionHeader.frame = CGRect(x: 20, y: 25, width: sectionheaderView.frame.width, height:25)
        labelForSectionHeader.text = "Payment Method"
        sectionheaderView.addSubview(labelForSectionHeader)
        
        return sectionheaderView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.selectionStyle = .none
        
        cell.imageView?.image = paymentOptions[indexPath.row].paymentTypeImage
        cell.textLabel?.text = paymentOptions[indexPath.row].paymentTypeName
        
        if let selectedPaymentOption = self.selectedPaymentOption{
            cell.accessoryType = paymentOptions[indexPath.row].paymentTypeName == selectedPaymentOption.paymentTypeName ? .checkmark : .none
            cell.accessoryView?.tintColor = UIColor.init(red: 0/255, green: 154/255, blue: 171/255, alpha: 1)
        }

        return cell
    }
    
    var oldIndexPath:IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if oldIndexPath == nil{
            oldIndexPath = indexPath
            cell?.accessoryType = .checkmark
        }else{
            let formerCell = tableView.cellForRow(at: oldIndexPath!)
            formerCell?.accessoryType = .none
            cell?.accessoryType = .checkmark
            oldIndexPath = indexPath
        }
        
        delegate?.getSelectedPaymentOption(selectedPaymentOption: paymentOptions[indexPath.row])
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let sectionFooterView = UIView()
        sectionFooterView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        sectionFooterView.backgroundColor = UIColor.groupTableViewBackground
        let addPaymentButton = UIButton(type: .system)
        addPaymentButton.tintColor = UIColor.init(red: 0/255, green: 154/255, blue: 171/255, alpha: 1)
        addPaymentButton.setTitle("Add Payment Method", for: .normal)
        addPaymentButton.addTarget(self, action: #selector(addPaymentMethodButtonPressed), for: .touchUpInside)
        addPaymentButton.frame = CGRect(x: 0, y: 20, width: sectionFooterView.frame.width, height:25)
        sectionFooterView.addSubview(addPaymentButton)
        
        return sectionFooterView
        
    }
    
    //MARK: View Overrides
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
                
        self.navigationItem.title = "Payment Options"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor]
        
        navigationController?.navigationBar.isTranslucent = false
        
        self.view.backgroundColor = .white
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
}
