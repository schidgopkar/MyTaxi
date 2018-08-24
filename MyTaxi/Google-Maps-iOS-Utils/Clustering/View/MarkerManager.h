//
//  Header.h
//  MyTaxi
//
//  Created by Shrikant Chidgopkar on 23/08/18.
//  Copyright © 2018 Shrikant Chidgopkar. All rights reserved.
//


#import <Foundation/Foundation.h>
@import CoreLocation;
#import "GMUClusterItem.h"
#import <GoogleMaps/GoogleMaps.h>


@interface MarkerManager: NSObject

@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) GMSMarker *marker;

@end
