//
//  ViewController.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 17/07/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - Properties
    
    private var pickUpshadowLayer: CAShapeLayer!
    
    private var dropOffContainerShadowLayer:CAShapeLayer!
    
    private var cornerRadius: CGFloat = 5
    
    private var fillColor: UIColor = .white
    
    var pickUpLineToMarkerShapeLayer:CAShapeLayer!
    
    var dropOffLineToMarkerShapeLayer:CAShapeLayer!
    
    var locationManager:CLLocationManager!
    
    var currentLocation:CLLocation?
    
    var pickUpCoordinate:CLLocationCoordinate2D?
    
    var dropOffCoordinate:CLLocationCoordinate2D?
    
    var driverCoordinates = [CLLocationCoordinate2D]()
    
    var isPickUpContainerViewOnTop:Bool = true
    
    var dropOffLabelTopConstraint:NSLayoutConstraint?
    
    var pickUpLabelTopConstraint:NSLayoutConstraint?
    
    let yellowMyTaxiColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
    
    let grayMyTaxiColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    
    var pickUpCameraPosition:GMSCameraPosition?
    
    var dropOffCameraPosition:GMSCameraPosition?
    
    var formattedAddress:String?
    
    var booking = Booking()
    
    var clusterManager: GMUClusterManager!
    
    var datePicker = UIDatePicker()
    
    let blackView = UIView()
    
    let scheduleTimeLabel = UILabel()
    
    var pickUpDateTime = ""

    
    //MARK: - View Properties

    var googleMapView:GMSMapView = {
       let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var markerView:UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "pickUpMarker")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let markerInfoView = MarkerInfoView()

    var pickupAddressContainerView:UIView = {
       let pickupView = UIView()
        pickupView.translatesAutoresizingMaskIntoConstraints = false
        pickupView.backgroundColor = .white
        return pickupView
    }()
    
    var dropOffAddressContainerView:UIView = {
        let dropOffView = UIView()
        dropOffView.translatesAutoresizingMaskIntoConstraints = false
        dropOffView.backgroundColor = UIColor.white
        return dropOffView
    }()
    
    var pickUpActivityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor(red: 72/255, green: 184/255, blue: 0/255, alpha: 1)
       return activityIndicator
    }()
    
    var dropOffActivityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor(red: 212/255, green: 0/255, blue: 79/255, alpha: 1)
        return activityIndicator
    }()

    
    var pickUpLabel:UILabel = {
       let pickLabel = UILabel()
        pickLabel.translatesAutoresizingMaskIntoConstraints = false
        pickLabel.textColor = UIColor(red: 72/255, green: 184/255, blue: 0/255, alpha: 1)
        pickLabel.text = "Pick up from"
        pickLabel.font = UIFont.systemFont(ofSize: 10)
        return pickLabel
    }()
    
    var pickUpAddressLabel:UILabel = {
       let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = UIFont.systemFont(ofSize: 13)
        addressLabel.text = "Getting Address"
        return addressLabel
    }()
    
    var pickUpImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "pickUpMarker")
        return imageView
    }()
    
    var dropOffLabel:UILabel = {
       let dropLabel = UILabel()
        dropLabel.translatesAutoresizingMaskIntoConstraints = false
        dropLabel.textColor = UIColor(red: 212/255, green: 0/255, blue: 79/255, alpha: 1)
        dropLabel.text = "Drop At"
        dropLabel.font = UIFont.systemFont(ofSize: 10)
        return dropLabel
    }()
    
    var dropOffAddressLabel:UILabel = {
       let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = UIFont.systemFont(ofSize: 13)
        addressLabel.text = "Choose drop location"
        addressLabel.textColor = UIColor.darkGray
        return addressLabel
    }()
    
    var dropOffImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "dropOffMarker")
        return imageView
    }()
    
    var bottomView:UIView = {
       let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    
    var preferanceLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        label.text = "Preferences"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   lazy var preferencesView: PreferencesCollectionView = {
       let pv = PreferencesCollectionView()
        pv.homeViewController = self
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    var saveAsDefaultLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        label.text = "Save as default"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var savePreferencesAsDefaulSwitch:UISwitch = {
        let saveSwitch = UISwitch()
        saveSwitch.isOn = true
        saveSwitch.onTintColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
        saveSwitch.translatesAutoresizingMaskIntoConstraints = false
        return saveSwitch
    }()
    
    var seperatorLiveView:UIView = {
       let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var bookATaxiButton:UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: "BOOK NOW", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tintColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        button.backgroundColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var datePickerContainerView:UIView = {
        let cView = UIView()
        cView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300)
        return cView
    }()
    
    var scheduleTaxiButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "schedule"), for: .normal)
        button.tintColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        button.backgroundColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var markerViewwidthAnchor:NSLayoutConstraint?
    
    
    //MARK: - Actions
    
    
    // Function to handle tap gesture recognizer on the pickUpContainerView
    
    @objc func pickUpTapped(){
        
        if !isPickUpContainerViewOnTop{
            if let pickUpCameraPosition = pickUpCameraPosition{
                self.googleMapView.animate(to: pickUpCameraPosition)
            }
            markerView.image = #imageLiteral(resourceName: "pickUpMarker")
            dropOffLineToMarkerShapeLayer.removeFromSuperlayer()
            dropOffContainerShadowLayer.removeFromSuperlayer()
            pickUpLabelTopConstraint?.constant = 2
            pickUpLabel.isHidden = false
            self.view.bringSubview(toFront: self.pickupAddressContainerView)
            isPickUpContainerViewOnTop = true
            pickUpAddressLabel.textColor = UIColor.black
            dropOffAddressLabel.textColor = UIColor.darkGray
            dropOffAddressContainerView.backgroundColor = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 1)
            pickupAddressContainerView.layer.insertSublayer(pickUpshadowLayer, at: 0)
            view.layer.addSublayer(pickUpLineToMarkerShapeLayer)
        }else{
            self.startGooglePlaceAutocompleteUI()
        }
        
    }
    
    
    // Function to handle tap gesture recognizer on the dropOffContainerView
    
    
    @objc func dropOfftapped(){
        
        self.markerViewwidthAnchor?.constant = 0
        
        if isPickUpContainerViewOnTop{
            if let dropOffCameraPosition = dropOffCameraPosition{
                self.googleMapView.animate(to: dropOffCameraPosition)
            }else{
                self.startGooglePlaceAutocompleteUI()
            }
            markerView.image = #imageLiteral(resourceName: "dropOffMarker")
            self.setUpBottomArrowPathAndShadowLayerForDropOffContainerView()
            self.setupDropOffMarker()
            pickUpLineToMarkerShapeLayer.removeFromSuperlayer()
            pickUpshadowLayer.removeFromSuperlayer()
            pickUpLabelTopConstraint?.constant = -12
            pickUpLabel.isHidden = true
            self.view.bringSubview(toFront: dropOffAddressContainerView)
            isPickUpContainerViewOnTop = false
            pickUpAddressLabel.textColor = UIColor.darkGray
            dropOffAddressLabel.textColor = UIColor.black
            pickupAddressContainerView.backgroundColor = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 1)
            dropOffAddressContainerView.layer.insertSublayer(dropOffContainerShadowLayer, at: 0)
            view.layer.addSublayer(dropOffLineToMarkerShapeLayer)
        }else{
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            
            self.present(autocompleteController, animated: true, completion: nil)
        }
        
    }
    
    //Starts Google places Autocomplete UI
    
    func startGooglePlaceAutocompleteUI(){
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        self.present(autocompleteController, animated: true, completion: nil)
        
    }
    
    // Pushes AccountViewController on UINavigation Stack when the user UIBarButtonItem is tapped
    
    @objc func userButtonTapped(){
        
        let accountViewController = AccountViewController()
        
        self.navigationController?.pushViewController(accountViewController, animated: true)
        
    }
    
    //Presents an AlertController to send message to the driver when the 'Send message' cell is selected on the Preferences collection view
    
    func messageDriverCellPressed(){
        
        let alert = UIAlertController(title: "Message Driver", message: nil, preferredStyle: .alert)
        let textView = UITextView()
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let controller = UIViewController()
        
        textView.frame = controller.view.frame
        controller.view.addSubview(textView)
        
        alert.setValue(controller, forKey: "contentViewController")
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.5)
        alert.view.addConstraint(height)
        
        let closeAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        let sendAction = UIAlertAction(title: "Send", style: .default) { (sendAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(closeAction)
        alert.addAction(sendAction)
    
        present(alert, animated: true, completion: nil)
        
    }

    // Action method when the 'Book Now' button is pressed
    
    @objc func bookTaxiButtonPressed(){
        
        if booking.pickUpCoordinates == nil{
            self.showAlertControllerwith(title: "Booking", message: "Pick up location is required", actionName: "Ok", action: {
                return
            })
        }else if booking.dropOffCoordinates == nil{
            self.showAlertControllerwith(title: "Booking", message: "Drop Off Location is Required", actionName: "Ok", action: {
                return
            })
        }
        
        let bookingDetailsViewController = BookingDetailsViewController()
        
        bookingDetailsViewController.booking = booking
        
        bookingDetailsViewController.driverCoordinates = driverCoordinates
        
        self.navigationController?.pushViewController(bookingDetailsViewController, animated: true)
    }
    
    //MARK: - Date and Time Picker Setup for Scheduling taxi
    
    
    //Action method which presents a 'dateTimePicker' when the 'schedule Taxi' button is tapped
    
    @objc func scheduleTaxiButtonTapped(){
        
        //cover the rest of the view with a translucent blackview when UIDatePicker is displayed
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        blackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(blackView)
        
        datePickerContainerView.backgroundColor = .white
        
        // Animate and show the datePickerContainerView coming from bottom of the screen
        
        UIView.animate(withDuration: 0.5) {
            self.datePickerContainerView.frame.origin.y = self.view.frame.height - self.datePickerContainerView.frame.height
        }
        
        self.view.addSubview(datePickerContainerView)
        
        //Setup a label showing the selected date and time.
        
        scheduleTimeLabel.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 30)
        scheduleTimeLabel.font = UIFont.boldSystemFont(ofSize: 17)
        scheduleTimeLabel.textColor = grayMyTaxiColor
        scheduleTimeLabel.textAlignment = .center
        datePickerContainerView.addSubview(scheduleTimeLabel)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd MMM,yyyy,hh:mm a"
        scheduleTimeLabel.text =  "Schedule At - " + timeFormatter.string(from: Date())
        
        //Setup a dateTime Picker
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.minimumDate = Date()
        datePicker.frame =  CGRect(x: 0, y: 70, width: self.view.frame.width, height: 200)
        datePickerContainerView.addSubview(datePicker)
        datePicker.addTarget(self, action:#selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
        
        //Setup a toolbar at the top of dateTimePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        
        toolBar.barStyle = UIBarStyle.black
        
        toolBar.isTranslucent = false
        
        toolBar.tintColor = UIColor.white
        
        //Setup UiBarButtonItems on the toolbar
        
        let toolBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(closeButtonPressed))
        
        toolBarButton.tintColor = .white
        
        let setAsPickUpTimeBarButton = UIBarButtonItem(title: "Set Pick Up Time", style: UIBarButtonItemStyle.done, target: self, action: #selector(setPickUpTimeToolBarButtonPressed))
        
        let resetBarButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.done, target: self, action: #selector(resetButtonPressed))
        
        resetBarButton.tintColor = .red
        
        setAsPickUpTimeBarButton.tintColor = yellowMyTaxiColor
        
        toolBar.items = [toolBarButton, resetBarButton, setAsPickUpTimeBarButton]
        
        datePickerContainerView.addSubview(toolBar)
        
    }
    
    // Handle the input from UIdatePicker
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.medium
        timeFormatter.timeStyle = DateFormatter.Style.short
        scheduleTimeLabel.text = "Schedule At - " + timeFormatter.string(from: sender.date)
        pickUpDateTime = timeFormatter.string(from: sender.date)
    }
    
    //Action button when "close" button is tapped in the UIDatePicker's toolbar
    
    @objc func closeButtonPressed(){
        datePicker.removeFromSuperview()
        UIView.animate(withDuration: 0.5) {
            self.blackView.removeFromSuperview()
            self.datePickerContainerView.frame.origin.y = self.view.frame.height + self.datePickerContainerView.frame.height
        }
    }
    
     //Action button when "Reset" button is tapped in the UIDatePicker's toolbar
    
    @objc func resetButtonPressed(){
        self.closeButtonPressed()
        let attributedTitle = NSAttributedString(string: "BOOK NOW", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
        bookATaxiButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    // Handle setting of pick up time selected from the UIDatePicker
    
    @objc func setPickUpTimeToolBarButtonPressed(){
        
        datePicker.removeFromSuperview()
        UIView.animate(withDuration: 0.5) {
            self.blackView.removeFromSuperview()
            self.datePickerContainerView.frame.origin.y = self.view.frame.height + self.datePickerContainerView.frame.height
        }
        setupBookATaxiButtonTextWhenScheduled()
    }
    
    // Animate Google Map to current location and draw a dotted line from pickUpContainer view to the Green Markers head using UIBezierPath
    
    func setUpPickUpMarkerOnMap(){
        
        let position = currentLocation?.coordinate
        if let position = position{
            let cameraPosition = GMSCameraPosition(target: position, zoom: 16, bearing: 0, viewingAngle: 0)
            googleMapView.animate(to: cameraPosition)
            
            if pickUpLineToMarkerShapeLayer == nil{
                
                // create path
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: pickupAddressContainerView.frame.midX , y: pickupAddressContainerView.frame.maxY + 10))
                path.addLine(to: CGPoint(x: markerView.frame.midX, y: markerView.frame.minY - 5))
                
                // Create a `CAShapeLayer` that uses that `UIBezierPath`:
                
                pickUpLineToMarkerShapeLayer = CAShapeLayer()
                pickUpLineToMarkerShapeLayer.path = path.cgPath
                pickUpLineToMarkerShapeLayer.strokeColor = UIColor.black.cgColor
                pickUpLineToMarkerShapeLayer.lineDashPattern = [2,3]
                pickUpLineToMarkerShapeLayer.fillColor = UIColor.clear.cgColor
                pickUpLineToMarkerShapeLayer.lineWidth = 2
                
                // Add that `CAShapeLayer` to your view's layer:
                
                view.layer.addSublayer(pickUpLineToMarkerShapeLayer)
            }
        }
        
    }
    
    
//    draw a dotted line from pickUpContainer view to the Pink Markers head using UIBezierPath
    
    func setupDropOffMarker(){
        
        if dropOffLineToMarkerShapeLayer == nil{
            
            // create path
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: dropOffAddressContainerView.frame.midX , y: dropOffAddressContainerView.frame.maxY + 10))
            path.addLine(to: CGPoint(x: markerView.frame.midX, y: markerView.frame.minY - 5))
            
            // Create a `CAShapeLayer` that uses that `UIBezierPath`:
            
            dropOffLineToMarkerShapeLayer = CAShapeLayer()
            dropOffLineToMarkerShapeLayer.path = path.cgPath
            dropOffLineToMarkerShapeLayer.strokeColor = UIColor.black.cgColor
            dropOffLineToMarkerShapeLayer.lineDashPattern = [2,3]
            dropOffLineToMarkerShapeLayer.fillColor = UIColor.clear.cgColor
            dropOffLineToMarkerShapeLayer.lineWidth = 2
            
            // Add that `CAShapeLayer` to your view's layer:
            
            view.layer.addSublayer(dropOffLineToMarkerShapeLayer)
        }
        
    }
    
    

    //MARK: - View and AutoLayout Setup
    
    
    func setupNavBar(){
        
        self.title = "MyTaxi"
        self.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let logoView = UIImageView.init(image: UIImage.init(named: "logo"))
        navigationItem.titleView = logoView
        
        let userImage = #imageLiteral(resourceName: "user").withRenderingMode(.alwaysTemplate)
        let userButton = UIBarButtonItem(image: userImage, style: .plain, target: self, action: #selector(userButtonTapped))
        navigationItem.rightBarButtonItem = userButton
        
    }

    
    func setupViews(){
        
        self.view.addSubview(googleMapView)
        self.view.addSubview(markerView)
        self.view.addSubview(markerInfoView)
        self.view.addSubview(pickupAddressContainerView)
        self.view.addSubview(dropOffAddressContainerView)
        pickupAddressContainerView.addSubview(pickUpImageView)
        pickupAddressContainerView.addSubview(pickUpLabel)
        pickupAddressContainerView.addSubview(pickUpAddressLabel)
        pickupAddressContainerView.addSubview(pickUpActivityIndicator)
        dropOffAddressContainerView.addSubview(dropOffImageView)
        dropOffAddressContainerView.addSubview(dropOffLabel)
        dropOffAddressContainerView.addSubview(dropOffAddressLabel)
        dropOffAddressContainerView.addSubview(dropOffActivityIndicator)
        self.view.addSubview(bottomView)
        bottomView.addSubview(preferanceLabel)
        bottomView.addSubview(saveAsDefaultLabel)
        bottomView.addSubview(savePreferencesAsDefaulSwitch)
        bottomView.addSubview(preferencesView)
        bottomView.addSubview(seperatorLiveView)
        bottomView.addSubview(bookATaxiButton)
        bottomView.addSubview(scheduleTaxiButton)
        
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                googleMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        }catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        
        NSLayoutConstraint.activate([
            markerView.centerXAnchor.constraint(equalTo: googleMapView.centerXAnchor),
            markerView.bottomAnchor.constraint(equalTo: googleMapView.centerYAnchor),
            markerView.widthAnchor.constraint(equalToConstant: 50),
            markerView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        view.bringSubview(toFront: markerView)
        
        markerInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        
        markerViewwidthAnchor = self.markerInfoView.widthAnchor.constraint(equalToConstant: 0)
        
            NSLayoutConstraint.activate([
                self.markerInfoView.leftAnchor.constraint(equalTo: self.markerView.rightAnchor, constant: -26),
                self.markerInfoView.topAnchor.constraint(equalTo: self.markerView.topAnchor),
                markerViewwidthAnchor!,
                self.markerInfoView.heightAnchor.constraint(equalToConstant: 20)
                ])
        
        
        NSLayoutConstraint.activate([
            pickupAddressContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            pickupAddressContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            pickupAddressContainerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            pickupAddressContainerView.heightAnchor.constraint(equalToConstant: 45)
            ])
        
        NSLayoutConstraint.activate([
            pickUpImageView.leftAnchor.constraint(equalTo: pickupAddressContainerView.leftAnchor, constant: 8),
            pickUpImageView.centerYAnchor.constraint(equalTo: pickupAddressContainerView.centerYAnchor),
            pickUpImageView.widthAnchor.constraint(equalToConstant: 20),
            pickUpImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        
        pickUpLabelTopConstraint = pickUpLabel.topAnchor.constraint(equalTo: pickupAddressContainerView.topAnchor, constant: 4)
        
        NSLayoutConstraint.activate([
            pickUpLabelTopConstraint!,
            pickUpLabel.leftAnchor.constraint(equalTo: pickupAddressContainerView.leftAnchor, constant: 36),
            pickUpLabel.rightAnchor.constraint(equalTo: pickupAddressContainerView.rightAnchor, constant: -4),
            pickUpLabel.heightAnchor.constraint(equalToConstant: 12)
            ])
        
        NSLayoutConstraint.activate([
            pickUpAddressLabel.leftAnchor.constraint(equalTo: pickUpLabel.leftAnchor),
            pickUpAddressLabel.rightAnchor.constraint(equalTo: pickupAddressContainerView.rightAnchor, constant: -4),
            pickUpAddressLabel.topAnchor.constraint(equalTo: pickUpLabel.bottomAnchor, constant: 2),
            pickUpAddressLabel.bottomAnchor.constraint(equalTo: pickupAddressContainerView.bottomAnchor, constant: -10)
            ])
        
        NSLayoutConstraint.activate([
            pickUpActivityIndicator.centerXAnchor.constraint(equalTo: pickupAddressContainerView.centerXAnchor),
            pickUpActivityIndicator.centerYAnchor.constraint(equalTo: pickupAddressContainerView.centerYAnchor),
            pickUpActivityIndicator.widthAnchor.constraint(equalToConstant: 20),
            pickUpActivityIndicator.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            dropOffAddressContainerView.leftAnchor.constraint(equalTo: pickupAddressContainerView.leftAnchor),
            dropOffAddressContainerView.rightAnchor.constraint(equalTo: pickupAddressContainerView.rightAnchor),
            dropOffAddressContainerView.topAnchor.constraint(equalTo: pickupAddressContainerView.bottomAnchor, constant: -11),
            dropOffAddressContainerView.heightAnchor.constraint(equalToConstant: 45)
            ])
        
        NSLayoutConstraint.activate([
            dropOffImageView.leftAnchor.constraint(equalTo: dropOffAddressContainerView.leftAnchor, constant: 8),
            dropOffImageView.centerYAnchor.constraint(equalTo: dropOffAddressContainerView.centerYAnchor),
            dropOffImageView.widthAnchor.constraint(equalToConstant: 20),
            dropOffImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            dropOffLabel.topAnchor.constraint(equalTo: dropOffAddressContainerView.topAnchor, constant: 2),
            dropOffLabel.leftAnchor.constraint(equalTo: dropOffAddressContainerView.leftAnchor, constant: 36),
            dropOffLabel.rightAnchor.constraint(equalTo: dropOffAddressContainerView.rightAnchor, constant: -10),
            dropOffLabel.heightAnchor.constraint(equalToConstant: 10)
            ])
        
        NSLayoutConstraint.activate([
            dropOffAddressLabel.leftAnchor.constraint(equalTo: dropOffLabel.leftAnchor),
            dropOffAddressLabel.rightAnchor.constraint(equalTo: dropOffAddressContainerView.rightAnchor, constant: -4),
            dropOffAddressLabel.topAnchor.constraint(equalTo: dropOffLabel.bottomAnchor, constant: 2),
            dropOffAddressLabel.bottomAnchor.constraint(equalTo: dropOffAddressContainerView.bottomAnchor, constant: -10)
            ])
        
        NSLayoutConstraint.activate([
            dropOffActivityIndicator.centerXAnchor.constraint(equalTo: dropOffAddressContainerView.centerXAnchor),
            dropOffActivityIndicator.centerYAnchor.constraint(equalTo: dropOffAddressContainerView.centerYAnchor),
            dropOffActivityIndicator.widthAnchor.constraint(equalToConstant: 20),
            dropOffActivityIndicator.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            bottomView.heightAnchor.constraint(equalToConstant: 160)
            ])
        
        savePreferencesAsDefaulSwitch.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        
        NSLayoutConstraint.activate([
            savePreferencesAsDefaulSwitch.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -6),
            savePreferencesAsDefaulSwitch.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2),
            ])
        
        
        NSLayoutConstraint.activate([
            saveAsDefaultLabel.rightAnchor.constraint(equalTo: savePreferencesAsDefaulSwitch.leftAnchor, constant: 0),
            saveAsDefaultLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 4),
            saveAsDefaultLabel.leftAnchor.constraint(equalTo: bottomView.centerXAnchor),
            saveAsDefaultLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        NSLayoutConstraint.activate([
            preferanceLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 8),
            preferanceLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 4),
            preferanceLabel.rightAnchor.constraint(equalTo: saveAsDefaultLabel.leftAnchor),
            preferanceLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        NSLayoutConstraint.activate([
            preferencesView.leftAnchor.constraint(equalTo: self.bottomView.leftAnchor, constant: 4),
            preferencesView.topAnchor.constraint(equalTo: preferanceLabel.bottomAnchor, constant: 4),
            preferencesView.widthAnchor.constraint(equalTo: self.bottomView.widthAnchor, constant: -4),
            preferencesView.heightAnchor.constraint(equalToConstant: 62)
            ])
        
        NSLayoutConstraint.activate([
            googleMapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            googleMapView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor),
            googleMapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            googleMapView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            seperatorLiveView.leftAnchor.constraint(equalTo: bottomView.leftAnchor),
            seperatorLiveView.topAnchor.constraint(equalTo: preferencesView.bottomAnchor, constant:2),
            seperatorLiveView.widthAnchor.constraint(equalTo: bottomView.widthAnchor),
            seperatorLiveView.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        NSLayoutConstraint.activate([
            scheduleTaxiButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -4),
            scheduleTaxiButton.topAnchor.constraint(equalTo: seperatorLiveView.bottomAnchor, constant: 4),
            scheduleTaxiButton.widthAnchor.constraint(equalToConstant: 45),
            scheduleTaxiButton.heightAnchor.constraint(equalToConstant: 45)
            ])
        
        NSLayoutConstraint.activate([
            bookATaxiButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 8),
            bookATaxiButton.topAnchor.constraint(equalTo: seperatorLiveView.bottomAnchor, constant: 4),
            bookATaxiButton.rightAnchor.constraint(equalTo: scheduleTaxiButton.leftAnchor, constant: -4),
            bookATaxiButton.heightAnchor.constraint(equalToConstant: 45)
            ])
        
        view.bringSubview(toFront: pickupAddressContainerView)
        
        let pickUpTapGesture = UITapGestureRecognizer(target: self, action: #selector(pickUpTapped))
        
        pickupAddressContainerView.addGestureRecognizer(pickUpTapGesture)
        
        let dropOffTapGesture = UITapGestureRecognizer(target: self, action: #selector(dropOfftapped))
        
        dropOffAddressContainerView.addGestureRecognizer(dropOffTapGesture)
    }
    
    
    // Draws the bottom arrow for the pickUpContainerView and adds shadowLayer to the container
    
    func setUpBottomArrowPathAndShadowLayerForPickUpContainerView(){
        
        if pickUpshadowLayer == nil{
            
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: pickupAddressContainerView.bounds.origin.x, y: pickupAddressContainerView.bounds.origin.y))
            path.addLine(to: CGPoint(x: pickupAddressContainerView.bounds.maxX, y: pickupAddressContainerView.bounds.origin.y))
            path.addLine(to: CGPoint(x: pickupAddressContainerView.bounds.maxX, y: pickupAddressContainerView.bounds.maxY))
            
            // Draw arrow
            path.addLine(to: CGPoint(x: pickupAddressContainerView.bounds.midX + 10, y: pickupAddressContainerView.bounds.maxY))
            path.addLine(to: CGPoint(x: pickupAddressContainerView.bounds.midX, y: pickupAddressContainerView.bounds.maxY + 10))
            path.addLine(to: CGPoint(x: pickupAddressContainerView.bounds.midX - 10, y: pickupAddressContainerView.bounds.maxY ))
            
            path.addLine(to: CGPoint(x: pickupAddressContainerView.bounds.origin.x, y: pickupAddressContainerView.bounds.maxY))
            path.close()
            
            pickUpshadowLayer = CAShapeLayer()
            
            pickUpshadowLayer.path = path.cgPath
            
            pickUpshadowLayer.fillColor = fillColor.cgColor
            
            pickupAddressContainerView.layer.masksToBounds = false
            
            pickUpshadowLayer.shadowColor = UIColor.darkGray.cgColor
            pickUpshadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            pickUpshadowLayer.shadowOpacity = 0.6
            pickUpshadowLayer.shadowRadius = 2
            
            pickUpshadowLayer.shadowPath = path.cgPath
            
            
            pickupAddressContainerView.layer.insertSublayer(pickUpshadowLayer, at: 0)
            
            
        }
        
    }
    
    // Draws the bottom arrow for the dropOffContainerView and adds shadowLayer to the container

    
    func setUpBottomArrowPathAndShadowLayerForDropOffContainerView(){
        
        if dropOffContainerShadowLayer == nil{
            
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: dropOffAddressContainerView.bounds.origin.x, y: dropOffAddressContainerView.bounds.origin.y))
            path.addLine(to: CGPoint(x: dropOffAddressContainerView.bounds.maxX, y: dropOffAddressContainerView.bounds.origin.y))
            path.addLine(to: CGPoint(x: dropOffAddressContainerView.bounds.maxX, y: dropOffAddressContainerView.bounds.maxY))
            
            // Draw arrow
            path.addLine(to: CGPoint(x: dropOffAddressContainerView.bounds.midX + 10, y: dropOffAddressContainerView.bounds.maxY))
            path.addLine(to: CGPoint(x: dropOffAddressContainerView.bounds.midX, y: dropOffAddressContainerView.bounds.maxY + 10))
            path.addLine(to: CGPoint(x: dropOffAddressContainerView.bounds.midX - 10, y: dropOffAddressContainerView.bounds.maxY ))
            
            path.addLine(to: CGPoint(x: dropOffAddressContainerView.bounds.origin.x, y: dropOffAddressContainerView.bounds.maxY))
            path.close()
            
            dropOffContainerShadowLayer = CAShapeLayer()
            
            dropOffContainerShadowLayer.path = path.cgPath
            
            dropOffContainerShadowLayer.fillColor = fillColor.cgColor
            
            dropOffAddressContainerView.layer.masksToBounds = false
            
            dropOffContainerShadowLayer.shadowColor = UIColor.darkGray.cgColor
            dropOffContainerShadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            dropOffContainerShadowLayer.shadowOpacity = 0.6
            dropOffContainerShadowLayer.shadowRadius = 2
            
            dropOffContainerShadowLayer.shadowPath = path.cgPath
            
            
            dropOffAddressContainerView.layer.insertSublayer(dropOffContainerShadowLayer, at: 0)
            
            
        }
        
        
    }
    
    // Adds attributed Title to the 'Book Now' button showing 'Schedule Taxi' and the selected pickUp date and time
    
    func setupBookATaxiButtonTextWhenScheduled(){
        
        bookATaxiButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        bookATaxiButton.titleLabel?.textAlignment = .center
        
        let buttonText: String = "SCHEDULE TAXI\n" +  pickUpDateTime
        
        //getting the range to separate the button title strings
        let newlineRange = buttonText.range(of: "\n")
        
        //getting both substrings
        var substring1: String = ""
        var substring2: String = ""
        
        if let range = newlineRange {
            substring1 = buttonText.substring(to: range.upperBound)
            substring2 = buttonText.substring(from: range.upperBound)
        }
        
        //assigning diffrent fonts to both substrings
        
        let font = UIFont.boldSystemFont(ofSize: 16)
        let textAttributes = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor,  NSAttributedStringKey.font: font]
        let attributedString = NSAttributedString(string: substring1 as String, attributes: textAttributes)
        
        
        
        let font1 = UIFont.systemFont(ofSize: 12)
        let textAttributes1 = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor,  NSAttributedStringKey.font: font1]
        let attributedString1 = NSAttributedString(string: substring2 as String, attributes: textAttributes1)
        
        
        //appending both attributed strings
        let finalAttributedString = NSMutableAttributedString()
        
        finalAttributedString.append(attributedString)
        finalAttributedString.append(attributedString1)
        
        //assigning the resultant attributed strings to the button
        bookATaxiButton.setAttributedTitle(finalAttributedString, for: .normal)
        
    }
    

    // MARK: - Core Location Setup and Delegate
    
    //Get the current location of the user
    
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations[0]
        
        locationManager.stopUpdatingLocation()
        
        self.setUpPickUpMarkerOnMap()
        
        
        let images: [UIImage] = [UIImage(named: "m1.png")!, UIImage(named: "m2.png")!, UIImage(named: "m3.png")!, UIImage(named: "m4.png")!, UIImage(named: "m5.png")!]
        
        let iconGenerator = GMUDefaultClusterIconGenerator.init(buckets: [10, 50, 100, 200, 500], backgroundImages: images)
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = CustomMarkers(mapView: googleMapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: googleMapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random driver items to the cluster manager.
        if let currentLocation = currentLocation{
            self.generateClusterItems(kCameraLatitude: currentLocation.coordinate.latitude, kCameraLongitude: currentLocation.coordinate.longitude)
        }

        // Call cluster() after items have been added to perform the clustering and rendering on map.
        clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
        
    }
    
    //MARK: - View Overrides

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setUpBottomArrowPathAndShadowLayerForPickUpContainerView()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        
        self.setupNavBar()
        
        googleMapView.delegate = self
        self.getCurrentLocation()
        self.setupViews()
        
    
        scheduleTaxiButton.addTarget(self, action: #selector(scheduleTaxiButtonTapped), for: .touchUpInside)
        
        bookATaxiButton.addTarget(self, action: #selector(bookTaxiButtonPressed), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


