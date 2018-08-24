//
//  AddPaymentMethodViewController.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 15/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit

protocol AddPaymentMethodDelegate {
    func paymentMethodWasAdded(paymentOption:PaymentOptions)
}

class AddPaymentMethodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CardIOPaymentViewControllerDelegate {
    
    //MARK: Properties
    
    var delegate:AddPaymentMethodDelegate?
        
    private let cellID = "cellID"
    
    let yellowMyTaxiColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)

    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    //MARK: Nav Bar and TableView Setup
    
    func setUpNavBar(){
        
        self.navigationItem.title = "Add Payment Method"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor]
        
        navigationController?.navigationBar.isTranslucent = false
        
        self.view.backgroundColor = .white
    }
    
    
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
        labelForSectionHeader.text = "Select a payment method to add"
        sectionheaderView.addSubview(labelForSectionHeader)
        
        return sectionheaderView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.selectionStyle = .none
        
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == 0{
            cell.imageView?.image = #imageLiteral(resourceName: "card")
            cell.textLabel?.text = "Credit/Debit Cards"
        }
        if indexPath.row == 1{
            cell.imageView?.image = #imageLiteral(resourceName: "paypal")
            cell.textLabel?.text = "Paypal Account"
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            self.startCardIOViewController()
        }
        if indexPath.row == 1{
            // Paypal SDK Code will go here
        }
        
    }
    
    // Starts the CardIOViewController to add new credit/debit card
    
    func startCardIOViewController(){
        
        
        let cardIOViewController = CardIOPaymentViewController(paymentDelegate: self)
        
        cardIOViewController?.modalPresentationStyle = .formSheet
        
        let grayMyTaxiColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    
        cardIOViewController?.navigationBarTintColorForCardIO = grayMyTaxiColor
        cardIOViewController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor]
        
        cardIOViewController?.navigationBar.isTranslucent = false
        
        cardIOViewController?.guideColor = yellowMyTaxiColor
        
        cardIOViewController?.keepStatusBarStyleForCardIO = true
        
        cardIOViewController?.detectionMode = .automatic
        
        cardIOViewController?.collectCardholderName = true
        
        self.present(cardIOViewController!, animated: true, completion: nil)
        
        
    }
    
    //MARK: - CardIO Delegate Methods
    
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            print(info.redactedCardNumber, info.cardholderName)
            var creditCardpaymentOption = PaymentOptions()
            
            if let cardNumber = info.redactedCardNumber{
                creditCardpaymentOption.paymentTypeName = cardNumber
            }
            let type = info.cardType
            
            switch type{
            case .unrecognized:
                creditCardpaymentOption.paymentTypeImage = #imageLiteral(resourceName: "card")
            case .ambiguous:
                creditCardpaymentOption.paymentTypeImage = #imageLiteral(resourceName: "card")
            case .amex:
                creditCardpaymentOption.paymentTypeImage = #imageLiteral(resourceName: "amex")
            case .JCB:
                creditCardpaymentOption.paymentTypeImage = #imageLiteral(resourceName: "jcb")
            case .visa:
                creditCardpaymentOption.paymentTypeImage = #imageLiteral(resourceName: "visa")
            case .mastercard:
                creditCardpaymentOption.paymentTypeImage = #imageLiteral(resourceName: "mastercard")
            case .discover:
                creditCardpaymentOption.paymentTypeImage = #imageLiteral(resourceName: "discover")
                break
            }
            delegate?.paymentMethodWasAdded(paymentOption: creditCardpaymentOption )
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: -  View Overrides
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        CardIOUtilities.preloadCardIO()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setUpNavBar()
        self.setUpTableView()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
