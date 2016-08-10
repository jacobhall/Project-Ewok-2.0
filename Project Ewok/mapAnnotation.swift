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
    
    var name: String;
    var title: String?;
    var subtitle: String?;
    var coordinate: CLLocationCoordinate2D;
    
    init(name: String, title: String? = nil, subtitle: String? = nil, coordinate: CLLocationCoordinate2D){
        self.name = name;
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = coordinate;
        super.init();
    }

    convenience init(name: String, title: String? = nil, subtitle: String? = nil, latitude: Double, longitude: Double){
        let CLLoc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        self.init(name: name, title: title, subtitle: subtitle, coordinate: CLLoc);
    }
    
    convenience override init(){
        let CLLoc = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        self.init(name: "", coordinate: CLLoc);
    }
}