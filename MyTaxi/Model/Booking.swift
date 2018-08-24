//
//  Booking.swift
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 10/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//

import UIKit
import CoreLocation


class Booking: NSObject {
    
    var pickUpAddress:String?
    var pickUpCoordinates:CLLocationCoordinate2D?
    var dropOffAddress:String?
    var dropOffCoordinates:CLLocationCoordinate2D?
    var driver:Driver?
    
}
