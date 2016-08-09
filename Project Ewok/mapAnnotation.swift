//
//  RestaurantAnnotation.swift
//  Restaurants Transit
//
//  Created by Malek T. on 1/21/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import MapKit

class mapAnnotation: NSObject, MKAnnotation {
    
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    override init() {
        name = ""
        
        coordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
    }

}