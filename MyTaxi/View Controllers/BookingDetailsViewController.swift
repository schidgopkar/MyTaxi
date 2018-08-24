//
//  BookingDetailsViewController.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 10/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit
import GoogleMaps

class BookingDetailsViewController: UIViewController, GMSMapViewDelegate, PaymentOptionsDelegate {
    
    //MARK: - Properties
    
    var booking = Booking()
    
    var driverCoordinates = [CLLocationCoordinate2D]()
    
    let pickUpMarker = GMSMarker()
    
    let dropOffMarker = GMSMarker()
    
    var greenCircleShapeLayer:CAShapeLayer?
    
    var redCircleShapeLayer:CAShapeLayer?
    
    var lineFromGreenCircleToRedCircle:CAShapeLayer!
    
    let yellowMyTaxiColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
    
    let grayMyTaxiColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    
    var paymentOption = PaymentOptions.init(paymentTypeName: "Cash", paymentTypeImage: #imageLiteral(resourceName: "cash"))
    
    var googleMapBottomAnchor:NSLayoutConstraint?
    
    var path = GMSPath()
    
    var encodedString:String!
    
    var polyLine:GMSPolyline!
    
    var animationPath = GMSMutablePath()
    
    var polyLineShapeLayer:CAShapeLayer?
    
    var layerAdded = false
    
    //MARK: - View Properties
    
    var googleMapView:GMSMapView = {
       let googleMapView = GMSMapView()
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        return googleMapView
    }()
    
    var addressesView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 1.0
        view.layer.zPosition = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    var pickUpAddressLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dropOffAddressLabel:UILabel = {
      let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bottomView:UIView = {
       let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    
    var priceLabel:UILabel = {
       let priceLabel = UILabel()
        priceLabel.text = "€ 10 - 15"
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.boldSystemFont(ofSize: 25)
        priceLabel.textColor = UIColor.black
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()
    
    var seperatorViewAfterPriceLable:UIView = {
        let sv = UIView()
        sv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var timeSheduleImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "schedule").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var dateTimeLabel:UILabel = {
        let dateTimeLabel = UILabel()
        dateTimeLabel.text = "Aug 10, 2018, 11:49 PM"
        dateTimeLabel.font = UIFont.systemFont(ofSize: 14)
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateTimeLabel
    }()
    
    var paymentTypeImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "cash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var paymentTypeLabel:UILabel = {
        let label = UILabel()
        label.text = "Cash"
        label.textColor = UIColor.init(red: 0/255, green: 154/255, blue: 171/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var confirmBookingButton:UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: "Confirm Booking", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tintColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        button.backgroundColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        button.addTarget(self, action: #selector(confirmBookingButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    //MARK: Actions
    
    
    @objc func confirmBookingButtonPressed(){
        
        let driverTrackingViewController = DriverTrackingViewController()
        driverTrackingViewController.booking = booking
        
        self.navigationController?.pushViewController(driverTrackingViewController, animated: true)
        
    }
    
    @objc func paymentLabelTapped(){
        
        let paymentOptionsViewController = PaymentOptionsViewController()
        
        paymentOptionsViewController.delegate = self
        
        paymentOptionsViewController.selectedPaymentOption = self.paymentOption
        
        self.navigationController?.pushViewController(paymentOptionsViewController, animated: true)
        
    }
    
    
    //MARK: - View and AutoLayout Setup
    
    
    func setupNavBar(){
        
        self.navigationItem.title = "Booking Details"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor]
        
        navigationController?.navigationBar.isTranslucent = false
        
        self.view.backgroundColor = UIColor.white
        
        let backItem = UIBarButtonItem()
        backItem.title = "back"
        navigationItem.backBarButtonItem = backItem
        
        
    }
    
    
    func setupGoogleMap(){
        
        // Set the custom map style by passing the URL of the local file.
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                googleMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        }catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        guard
        let pickUpCoordinate = self.booking.pickUpCoordinates,
        let dropOffCoordinate = self.booking.dropOffCoordinates
        else {
            return
        }
        pickUpMarker.position = pickUpCoordinate
        pickUpMarker.icon = #imageLiteral(resourceName: "pickUpRealMarker")
        pickUpMarker.map = googleMapView
        
        dropOffMarker.position = dropOffCoordinate
        dropOffMarker.icon = #imageLiteral(resourceName: "dropOffMarker")
        dropOffMarker.map = googleMapView
        
        let bounds = GMSCoordinateBounds(coordinate: pickUpCoordinate, coordinate: dropOffCoordinate)
        let camera = googleMapView.camera(for: bounds, insets: UIEdgeInsets())!
        googleMapView.animate(to: camera)
        
        pickUpMarker.zIndex = 10
        
        dropOffMarker.zIndex = 10
        
    }
    
    func setUpViews(){
        
        self.view.addSubview(addressesView)
        self.view.addSubview(googleMapView)
        addressesView.addSubview(pickUpAddressLabel)
        addressesView.addSubview(dropOffAddressLabel)
        self.view.addSubview(bottomView)
        bottomView.addSubview(priceLabel)
        bottomView.addSubview(seperatorViewAfterPriceLable)
        bottomView.addSubview(timeSheduleImageView)
        bottomView.addSubview(dateTimeLabel)
        bottomView.addSubview(paymentTypeImageView)
        bottomView.addSubview(paymentTypeLabel)
        bottomView.addSubview(confirmBookingButton)
        
        NSLayoutConstraint.activate([
            addressesView.topAnchor.constraint(equalTo: self.view.topAnchor),
            addressesView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            addressesView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            addressesView.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        NSLayoutConstraint.activate([
            pickUpAddressLabel.leftAnchor.constraint(equalTo: addressesView.leftAnchor, constant: 24),
            pickUpAddressLabel.rightAnchor.constraint(equalTo: addressesView.rightAnchor, constant: -4),
            pickUpAddressLabel.topAnchor.constraint(equalTo: addressesView.topAnchor, constant: 0),
            pickUpAddressLabel.heightAnchor.constraint(equalTo: addressesView.heightAnchor, multiplier: 0.5)
            ])
        
        NSLayoutConstraint.activate([
            dropOffAddressLabel.leftAnchor.constraint(equalTo: addressesView.leftAnchor, constant: 24),
            dropOffAddressLabel.rightAnchor.constraint(equalTo: addressesView.rightAnchor, constant: -4),
            dropOffAddressLabel.topAnchor.constraint(equalTo: pickUpAddressLabel.bottomAnchor, constant: 0),
            dropOffAddressLabel.heightAnchor.constraint(equalTo: addressesView.heightAnchor, multiplier: 0.5)
    
            ])
        
        NSLayoutConstraint.activate([
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 180)
            ])
        
        
        googleMapBottomAnchor = googleMapView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor)
        
        NSLayoutConstraint.activate([
            googleMapView.topAnchor.constraint(equalTo: addressesView.bottomAnchor),
            googleMapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            googleMapView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            googleMapBottomAnchor!
            ])
        
        NSLayoutConstraint.activate([
            priceLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            priceLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2),
            priceLabel.widthAnchor.constraint(equalTo: bottomView.widthAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            seperatorViewAfterPriceLable.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 20),
            seperatorViewAfterPriceLable.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            seperatorViewAfterPriceLable.widthAnchor.constraint(equalTo: bottomView.widthAnchor, constant: -40),
            seperatorViewAfterPriceLable.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        NSLayoutConstraint.activate([
            timeSheduleImageView.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 20),
            timeSheduleImageView.topAnchor.constraint(equalTo: seperatorViewAfterPriceLable.bottomAnchor, constant: 10),
            timeSheduleImageView.widthAnchor.constraint(equalToConstant: 25),
            timeSheduleImageView.heightAnchor.constraint(equalToConstant: 25)
            ])
        
        NSLayoutConstraint.activate([
            dateTimeLabel.leftAnchor.constraint(equalTo: timeSheduleImageView.rightAnchor, constant: 15),
            dateTimeLabel.centerYAnchor.constraint(equalTo: timeSheduleImageView.centerYAnchor),
            dateTimeLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20),
            dateTimeLabel.heightAnchor.constraint(equalToConstant: 25)
            ])
        
        NSLayoutConstraint.activate([
            paymentTypeImageView.leftAnchor.constraint(equalTo: timeSheduleImageView.leftAnchor, constant: -2),
            paymentTypeImageView.topAnchor.constraint(equalTo: timeSheduleImageView.bottomAnchor, constant: 10),
            paymentTypeImageView.widthAnchor.constraint(equalToConstant: 35),
            paymentTypeImageView.heightAnchor.constraint(equalToConstant: 35)
            ])
        
        
        NSLayoutConstraint.activate([
            paymentTypeLabel.leftAnchor.constraint(equalTo: dateTimeLabel.leftAnchor),
            paymentTypeLabel.centerYAnchor.constraint(equalTo: paymentTypeImageView.centerYAnchor),
            paymentTypeLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20),
            paymentTypeLabel.heightAnchor.constraint(equalToConstant: 25)
            ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(paymentLabelTapped))
        
        paymentTypeLabel.addGestureRecognizer(tapGestureRecognizer)
        
        paymentTypeLabel.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            confirmBookingButton.leftAnchor.constraint(equalTo: paymentTypeImageView.leftAnchor),
            confirmBookingButton.rightAnchor.constraint(equalTo: paymentTypeLabel.rightAnchor),
            confirmBookingButton.topAnchor.constraint(equalTo: paymentTypeImageView.bottomAnchor, constant: 10),
            confirmBookingButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -5)
            ])
        
        
        let greenColor = UIColor(red: 67/255, green: 182/255, blue: 0/255, alpha: 1)
        
        let pinkColor = UIColor(red: 210/255, green: 0/255, blue: 80/255, alpha: 1)
        
         greenCircleShapeLayer = self.drawCircleWith(radius: 3, fillColor: greenColor, strokeColor: UIColor.green, lineWidth: 0.5, inView: addressesView, arcCenter: CGPoint(x: 13, y: 15))
        
        redCircleShapeLayer = self.drawCircleWith(radius: 3, fillColor: pinkColor, strokeColor: UIColor.red, lineWidth: 0.5, inView: addressesView, arcCenter: CGPoint(x: 13, y: 45))
        
        guard
            let pickUpAddress = self.booking.pickUpAddress,
            let dropOffAddress = self.booking.dropOffAddress
            else {
            return
        }
        
        self.pickUpAddressLabel.text = pickUpAddress
        self.dropOffAddressLabel.text = dropOffAddress
        
    }
    
    
    // Draws dotted line betwen green and pink circles in the addressView
    
    func drawDottedLine(){
        
        if let _ = greenCircleShapeLayer, let _ = redCircleShapeLayer{
            
            if lineFromGreenCircleToRedCircle == nil {
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 13 , y: 19))
                path.addLine(to: CGPoint(x: 13, y: 41))
        
                // Create a `CAShapeLayer` that uses that `UIBezierPath`:
        
                lineFromGreenCircleToRedCircle = CAShapeLayer()
                lineFromGreenCircleToRedCircle.path = path.cgPath
                lineFromGreenCircleToRedCircle.strokeColor = UIColor.lightGray.cgColor
                lineFromGreenCircleToRedCircle.lineDashPattern = [2,3]
                lineFromGreenCircleToRedCircle.fillColor = UIColor.clear.cgColor
                lineFromGreenCircleToRedCircle.lineWidth = 0.5
        
                // Add that `CAShapeLayer` to your view's layer:
        
                addressesView.layer.addSublayer(lineFromGreenCircleToRedCircle)
            }
        }
        
    }
    
    
    // Gets the Encoded polyline between pickUp and dropOff locations using the google's direction API


    func getDirectionEncodedString(originLatitude:String,originLongitude:String,destinationLatitude:String,destinationLongitude:String,withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
        let apiKey = "AIzaSyDVvArWNDNF-uNb5CuKLX-Eglha60yrwJo"
        
        let urlString =  "https://maps.googleapis.com/maps/api/directions/json?origin=\(originLatitude),\(originLongitude)&destination=\(destinationLatitude),\(destinationLongitude)&key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        print(urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                print("Google GEOCODEING ERROR IS",error)
                completionHandler("\(error)",false)
                return
            }
            
            DispatchQueue.main.async {
                
            do{
                if let unwrappeddata = data,let jsonObject = try JSONSerialization.jsonObject(with: unwrappeddata, options:JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]{
                    
                    print(jsonObject)
                    
                    let status = jsonObject["status"] as! String
                    
                    if status == "OK" {
                        
                        guard
                            
                            let routes = jsonObject["routes"] as? [[String:Any]],
                            let overviewPolyline = routes[0]["overview_polyline"] as? [String:Any],
                            let points = overviewPolyline["points"] as? String,
                            let legs = routes[0]["legs"] as? [[String:Any]],
                            let duration = legs[0]["duration"] as? [String:Any],
                            let durationText = duration["text"] as? String
                            
                            else{return}
                        
                        self.path = GMSPath.init(fromEncodedPath: points )!
                        self.encodedString = points
                        
                        let bounds = GMSCoordinateBounds.init(path: self.path)
                    
                        self.googleMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 60.0))
                        
                        self.addPolyLineWithEncodedStringInMap(self.encodedString)
                        
                        self.dropOffMarker.snippet = durationText
                        
                        self.googleMapView.selectedMarker = self.dropOffMarker

                    }
                    completionHandler("\(status)",true)
                    
                }
            }
            catch let error as NSError {
                print(error)
                completionHandler("\(error)",false)
            }
        }
        }.resume()
        
    }
    

    // Adds the polyLine to the GMSMapview
    
    
    func addPolyLineWithEncodedStringInMap(_ encodedString:String) {
        self.polyLine = GMSPolyline(path: self.path)
        polyLine.strokeWidth = 3.5
        self.polyLine.strokeColor = UIColor.black.withAlphaComponent(0.8)
        polyLine.map = googleMapView
        
        // Add a CAShapeLayer on top of the polyline and animate it
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.addPolyLineShapeLayerToMapView()
            self.layerAdded = true
        }
        
    }
    
    // Add a CAShapeLayer on top of the polyline
    
    func layer(from path: GMSPath) -> CAShapeLayer {
        let breizerPath = UIBezierPath()
        let firstCoordinate: CLLocationCoordinate2D = path.coordinate(at: 0)
        breizerPath.move(to: self.googleMapView.projection.point(for: firstCoordinate))
        for i in 1 ..< Int((path.count())){
            print(path.coordinate(at: UInt(i)))
            let coordinate: CLLocationCoordinate2D = path.coordinate(at: UInt(i))
            breizerPath.addLine(to: self.googleMapView.projection.point(for: coordinate))
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = breizerPath.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        shapeLayer.lineWidth = 4.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineDashPattern = [2,3]
        shapeLayer.cornerRadius = 5
        return shapeLayer
    }
    
    // Animate the CAShapeLayer
    
    func animatePath(_ layer: CAShapeLayer) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.fromValue = Int(0.0)
        pathAnimation.toValue = Int(1.0)
        pathAnimation.repeatCount = 200
        layer.add(pathAnimation, forKey: "strokeEnd")
    }
    
    // Insert the polyLineShapeLayer as a sublayer to GMSMapView
    
    func addPolyLineShapeLayerToMapView(){
        
        polyLineShapeLayer = self.layer(from: self.path)
        
        if let polyLineShapeLayer = polyLineShapeLayer{
            self.animatePath(polyLineShapeLayer)
            self.googleMapView.layer.insertSublayer(polyLineShapeLayer, at: 1)
        }
        
    }
    
    
    //MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if layerAdded{
            DispatchQueue.main.async {
                self.polyLineShapeLayer?.removeFromSuperlayer()
                self.polyLineShapeLayer = nil
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if self.layerAdded{
            self.addPolyLineShapeLayerToMapView()
       }
        
    }
    
    
    //MARK: - PaymentOptionsDelegate method 
    
    // PaymentOptionDelegate method to get the selected payment option in PaymentOptionsViewController
    
    
    func getSelectedPaymentOption(selectedPaymentOption: PaymentOptions) {
        
        self.paymentOption = selectedPaymentOption
        
        self.setSelectedPaymentOption()
        
    }
    
    // set the selected Payment option and update the UI
    
    func setSelectedPaymentOption(){
        
        guard
            let paymentTypeName = paymentOption.paymentTypeName,
            let paymentImage = paymentOption.paymentTypeImage
            else{return}
        self.paymentTypeImageView.image = paymentImage
        self.paymentTypeLabel.text = paymentTypeName
        
    }
    
    //MARK: - View Overrides
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            if self.layerAdded{
                if let layer = self.polyLineShapeLayer{
                    self.animatePath(layer)
                }
            }
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setUpViews()
        self.drawDottedLine()
        
        self.setupGoogleMap()
        googleMapView.delegate = self
        
        
        guard
            let pickUpCoordinate = self.booking.pickUpCoordinates,
            let dropOffCoordinate = self.booking.dropOffCoordinates
            else {return}
        
            self.getDirectionEncodedString(originLatitude:"\(pickUpCoordinate.latitude)", originLongitude: "\(pickUpCoordinate.longitude)", destinationLatitude: "\(dropOffCoordinate.latitude)", destinationLongitude: "\(dropOffCoordinate.longitude)") { (status, success) in
            }
    }

}




