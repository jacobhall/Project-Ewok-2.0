//
//  RestaurantAnnotation.swift
//  Restaurants Transit
//
//  Created by Malek T. on 1/21/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import MapKit

class mapAnnotation: MKAnnotation {
    
    @objc var title: String?;
    @objc var subtitle: String?;
    let coordinates: CLLocationCoordinate2D;
    
    init(title: String? = nil, subtitle: String? = nil, coordinates: CLLocationCoordinate2D){
        self.title = title;
        self.subtitle = subtitle;
        self.coordinates = coordinates;
    }
    
    convenience init(title: String? = nil, subtitle: String? = nil, latitude: Double, longitude: Double){
        let CLLoc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        self.init(title: title, subtitle: subtitle, coordinates: CLLoc);
    }
}