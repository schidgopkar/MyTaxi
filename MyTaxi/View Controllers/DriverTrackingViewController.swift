//
//  DriverTrackingViewController.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 17/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit
import GoogleMaps

class DriverTrackingViewController:UIViewController, GMSMapViewDelegate{
    
    //MARK: - Properties
    
    var booking = Booking()
    
    var path = GMSPath()
    
    var encodedString:String!
    
    var polyLine:GMSPolyline!
    
    var polyLineShapeLayer:CAShapeLayer?
    
    var layerAdded = false
    
    var animationPath = GMSMutablePath()
    
    var greenCircleShapeLayer:CAShapeLayer?
    
    var redCircleShapeLayer:CAShapeLayer?
    
    var lineFromGreenCircleToRedCircle:CAShapeLayer!
    
    let yellowMyTaxiColor = UIColor.init(red: 255/255, green: 197/255, blue: 0/255, alpha: 1)
    
    var driverAndRideDetailsView = DriverAndRideDetailsView()
    
    let pickUpMarker = GMSMarker()
    
    let driverMarker = GMSMarker()
    
    let infoWindow = InfoWindowView()
    
    var minutesLeftToArrival:String = ""
    
    
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
    
    

    //MARK: - Setup View and AutoLayout
    
    
    func setupNavBar(){
        
        self.navigationItem.title = ""
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:yellowMyTaxiColor]
        
        navigationController?.navigationBar.isTranslucent = false
        
        self.view.backgroundColor = UIColor.white
        
        
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
            let driversCoordinate = self.booking.driver?.currentlocation
            else {
                return
        }
        pickUpMarker.position = pickUpCoordinate
        pickUpMarker.icon = #imageLiteral(resourceName: "pickUpRealMarker")
        pickUpMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.25)
        pickUpMarker.tracksInfoWindowChanges = true
        pickUpMarker.map = googleMapView
        
        driverMarker.position = driversCoordinate
        driverMarker.icon = #imageLiteral(resourceName: "driverMarker")
        driverMarker.map = googleMapView
        
    }
    
    
    func setUpViews(){
        
        self.view.addSubview(addressesView)
        self.view.addSubview(googleMapView)
        self.view.addSubview(driverAndRideDetailsView)
        addressesView.addSubview(pickUpAddressLabel)
        addressesView.addSubview(dropOffAddressLabel)
        
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
        
        
        driverAndRideDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            driverAndRideDetailsView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            driverAndRideDetailsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            driverAndRideDetailsView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            driverAndRideDetailsView.heightAnchor.constraint(equalToConstant: 170)
            ])
        
        let taxiNumber = "TXHG - 12345"
        
        let widthOfTaxiNumber = taxiNumber.width(withConstrainedHeight: 40, font: UIFont.boldSystemFont(ofSize: 16)) + 4
        
        driverAndRideDetailsView.carNumberPlateWidthConstraint?.constant = widthOfTaxiNumber
        
        driverAndRideDetailsView.carNumberPlateLabel.text = taxiNumber
        
    
        NSLayoutConstraint.activate([
            googleMapView.topAnchor.constraint(equalTo: addressesView.bottomAnchor),
            googleMapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            googleMapView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            googleMapView.bottomAnchor.constraint(equalTo: driverAndRideDetailsView.topAnchor)
            ])
    
        
        let greenColor = UIColor(red: 67/255, green: 182/255, blue: 0/255, alpha: 1)
        
        let pinkColor = UIColor(red: 210/255, green: 0/255, blue: 80/255, alpha: 1)
        
        greenCircleShapeLayer = self.drawCircleWith(radius: 3, fillColor: greenColor, strokeColor: UIColor.green, lineWidth: 0.5, inView: addressesView, arcCenter: CGPoint(x: 13, y: 15))
        
        redCircleShapeLayer = self.drawCircleWith(radius: 3, fillColor: pinkColor, strokeColor: UIColor.red, lineWidth: 0.5, inView: addressesView, arcCenter: CGPoint(x: 13, y: 45))
        
        self.drawDottedLine()
        
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
                            
                            print("LEGS ARE***********", legs)
                            
                            self.minutesLeftToArrival = durationText
                            
                            self.path = GMSPath.init(fromEncodedPath: points )!
                            self.encodedString = points
                            
                            let bounds = GMSCoordinateBounds.init(path: self.path)

                            self.googleMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))

                            self.addPolyLineWithEncodedStringInMap(self.encodedString)
                            
                            
                            self.googleMapView.selectedMarker = self.pickUpMarker
                            
                            self.navigationItem.title = "Arriving, \(self.minutesLeftToArrival) away"
             
                            
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
    
    
    
    func addPolyLineWithEncodedStringInMap(_ encodedString:String) {
        self.polyLine = GMSPolyline(path: self.path)
        polyLine.strokeWidth = 4
        self.polyLine.strokeColor = .black
        polyLine.map = googleMapView
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.addPolyLineShapeLayerToMapView()
            self.layerAdded = true
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

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        if marker == pickUpMarker{
            infoWindow.timeRemainingLabel.text = minutesLeftToArrival
            return infoWindow
        }

        return nil
    }



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
        shapeLayer.cornerRadius = 5
        return shapeLayer
    }

    func animatePath(_ layer: CAShapeLayer) {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.fromValue = Int(0.0)
        pathAnimation.toValue = Int(1.0)
        pathAnimation.repeatCount = 200
        layer.add(pathAnimation, forKey: "strokeEnd")
    }

    func addPolyLineShapeLayerToMapView(){

        polyLineShapeLayer = self.layer(from: self.path)

        if let polyLineShapeLayer = polyLineShapeLayer{
            self.animatePath(polyLineShapeLayer)
            self.googleMapView.layer.insertSublayer(polyLineShapeLayer, below: googleMapView.layer.sublayers?[1])
        }

    }
    
    
    //MARK: - View Overrides

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Make Driver Image Circular
        
        driverAndRideDetailsView.driverImageView.layer.borderWidth = 1
        driverAndRideDetailsView.driverImageView.layer.masksToBounds = false
        driverAndRideDetailsView.driverImageView.layer.borderColor = UIColor.black.cgColor
        driverAndRideDetailsView.driverImageView.layer.cornerRadius = driverAndRideDetailsView.driverImageView.frame.height / 2
        driverAndRideDetailsView.driverImageView.clipsToBounds = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setUpViews()
        self.setupGoogleMap()
        
        googleMapView.delegate = self

        guard
            let pickUpCoordinate = self.booking.pickUpCoordinates,
            let driversCoordinate = self.booking.driver?.currentlocation
            else {
                return
            }
        
        self.getDirectionEncodedString(originLatitude: String(driversCoordinate.latitude), originLongitude: String(driversCoordinate.longitude), destinationLatitude: String(pickUpCoordinate.latitude), destinationLongitude: String(pickUpCoordinate.longitude)) { (status, success) in
        }
        
    }
    
}
