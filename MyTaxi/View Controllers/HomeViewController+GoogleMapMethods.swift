//
//  HomeViewController+GoogleMapMethods.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 22/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Foundation

extension HomeViewController: GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, GMUClusterManagerDelegate{
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? DriverItem {
            print("Did tap marker", poiItem.position)
        } else {
            print("Did tap a normal marker")
        }
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        self.markerViewwidthAnchor?.constant = 0
        
        if gesture{
            if self.isPickUpContainerViewOnTop{
                self.pickUpAddressLabel.text = "Fetching Address..."
                self.dropOffAddressContainerView.isHidden = true
                self.pickUpActivityIndicator.startAnimating()
            }else{
                self.pickupAddressContainerView.isHidden = true
                self.dropOffAddressLabel.text = "Fetching Address..."
                self.dropOffActivityIndicator.startAnimating()
            }
        }
        
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let bottomOfMarkerView = CGPoint(x: markerView.frame.midX, y: markerView.frame.maxY)
        let coordinate = mapView.projection.coordinate(for: bottomOfMarkerView )
        
        self.pickupAddressContainerView.isHidden = false
        self.dropOffAddressContainerView.isHidden = false
        
        self.formattedAddress = ""
        
        self.reverseGeocodeAddress(latitude: "\(coordinate.latitude)", longitude: "\(coordinate.longitude)") { (formattedAddress, success) in
            if success{
                self.formattedAddress = formattedAddress
                DispatchQueue.main.async {
                    if self.isPickUpContainerViewOnTop{
                        if let address = self.formattedAddress{
                            self.pickUpAddressLabel.text = address
                            self.booking.pickUpAddress = address
                            self.pickUpActivityIndicator.stopAnimating()
                        }else{
                            self.pickUpAddressLabel.text = "Pin location"
                        }
                    }else{
                        if let address = self.formattedAddress{
                            self.dropOffAddressLabel.text = address
                            self.booking.dropOffAddress = address
                            self.dropOffActivityIndicator.stopAnimating()
                        }else{
                            self.dropOffAddressLabel.text = "Pin location"
                        }
                        
                    }
                }
            }
        }
        if isPickUpContainerViewOnTop{
            booking.pickUpCoordinates = coordinate
            pickUpCameraPosition = position
            
            findTheNearestDriverFromLocation(location: CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude))
            self.markerViewwidthAnchor?.constant = 70
            
            UIView.animate(withDuration: 0.3, animations: {
                self.markerInfoView.frame.size.width = 70
            })
        }else{
            booking.dropOffCoordinates = coordinate
            dropOffCameraPosition = position
        }
        
        
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        let position = currentLocation?.coordinate
        
        if let position = position{
            let cameraPosition = GMSCameraPosition(target: position, zoom: 16, bearing: 0, viewingAngle: 0)
            googleMapView.animate(to: cameraPosition)
        }
        
        return true
    }
    

    //MARK: - GMSAutocompleteViewControllerDelegate

    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        dismiss(animated: true, completion: nil)
        
        let position = place.coordinate
        DispatchQueue.main.async {
            self.googleMapView.animate(toLocation: position)
        }
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    


    // MARK: - GMUClusterManagerDelegate


    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                             zoom: googleMapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        googleMapView.moveCamera(update)
        return false
    }
    
    
    //MARK: - Helpers
    
    /// Randomly generate 1000 coordinates for drivers within some extent of the camera and add to the google map
    
    func generateClusterItems(kCameraLatitude:Double, kCameraLongitude:Double) {
        let extent = 0.2
        for _ in 1...1000{
            let lat = kCameraLatitude + extent * randomScale()
            let lng = kCameraLongitude + extent * randomScale()
            let randomDriverCoordinate = CLLocationCoordinate2DMake(lat, lng)
            let marker = GMSMarker()
            marker.icon = #imageLiteral(resourceName: "driverMarker")
            marker.rotation = CLLocationDegrees(arc4random_uniform(180))
            let driverItem = DriverItem(position: randomDriverCoordinate, marker: marker)
            driverCoordinates.append(randomDriverCoordinate)
            clusterManager.add(driverItem)
        }
    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    // FInds the nearest driver to the pick up location and finds the duration from the driver's location to pickup location using google's distance matrix API
    
    func findTheNearestDriverFromLocation(location:CLLocation){
        
        self.markerInfoView.timeLabel.text = ""
        self.markerInfoView.activityIndicator.startAnimating()
        
        var closestDriversLocation: CLLocation?
        var smallestDistance: CLLocationDistance?
        
        for coordinate in driverCoordinates{
            
            let driversLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            let calculatedDistance = location.distance(from: driversLocation)
            
            if smallestDistance == nil || calculatedDistance < smallestDistance! {
                closestDriversLocation = driversLocation
                smallestDistance = calculatedDistance
            }
        }
        
        guard let closestLocation = closestDriversLocation  else{return}
                
        var driver = Driver()
        
        driver.currentlocation = closestLocation.coordinate
        
        booking.driver = driver
        
        let originCoordinateDriver = closestLocation.coordinate
        let destinationCoordinate = location.coordinate
        
        let apiKey = "AIzaSyDVvArWNDNF-uNb5CuKLX-Eglha60yrwJo"
        
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(originCoordinateDriver.latitude),\(originCoordinateDriver.longitude)&destinations=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        guard let unWrappedUrl = url else {return}
        
        URLSession.shared.dataTask(with: unWrappedUrl) { (data, response, error) in
            
            if let error = error{
                print(error)
                return
            }
            
            do{
                
                if let data = data, let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    
                    guard let status = jsonObject["status"] as? String else{return}
                    
                    if status == "OK"{
                        guard
                            let rows = jsonObject["rows"] as? [[String:Any]],
                            let elements = rows[0]["elements"] as? [[String:Any]],
                            let duration = elements[0]["duration"] as? [String:Any],
                            let durationText = duration["text"] as? String
                            
                            else{return}
                        
                        DispatchQueue.main.async {
                            self.markerInfoView.activityIndicator.stopAnimating()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                            self.markerInfoView.timeLabel.text = durationText
                        })
                    }
                }
            }catch let error as NSError{
                print(error)
            }
            }.resume()
        
    }

}


/// Driver Item class which implements the GMUClusterItem protocol.

class DriverItem: NSObject, GMUClusterItem {
    
    var position: CLLocationCoordinate2D
    @objc var marker: GMSMarker!
    
    init(position: CLLocationCoordinate2D, marker: GMSMarker) {
        self.position = position
        self.marker = marker
    }
}

// Extend GMUDefaultClusterRenderer to get access to the default google's red marker and change it to car marker

class CustomMarkers: GMUDefaultClusterRenderer {
    
    var mapView:GMSMapView?
    let kGMUAnimationDuration: Double = 0.5
    
    override init(mapView: GMSMapView, clusterIconGenerator iconGenerator: GMUClusterIconGenerator) {
        
        super.init(mapView: mapView, clusterIconGenerator: iconGenerator)
    }
    
    func markerWithPosition(position: CLLocationCoordinate2D, from: CLLocationCoordinate2D, userData: AnyObject, clusterIcon: UIImage, animated: Bool) -> GMSMarker {
        let initialPosition = animated ? from : position
        let marker = GMSMarker(position: initialPosition)
        marker.userData! = userData
        if clusterIcon.cgImage != nil {
            marker.icon = clusterIcon
        }
        else {
            marker.icon = self.getCustomTitleItem(userData: userData)
        }
        marker.map = mapView
        if animated
        {
            CATransaction.begin()
            CAAnimation.init().duration = kGMUAnimationDuration
            marker.layer.latitude = position.latitude
            marker.layer.longitude = position.longitude
            CATransaction.commit()
        }
        return marker
    }
    
    func getCustomTitleItem(userData: AnyObject) -> UIImage {
        let item = userData as! DriverItem
        return item.marker.icon!
    }
}
