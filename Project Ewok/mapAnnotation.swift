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
    
    let geolocationID: Int;
    var name: String;
    var title: String?;
    var subtitle: String?;
    var coordinate: CLLocationCoordinate2D;
    
    init(name: String, title: String? = nil, subtitle: String? = nil, geolocationID: Int, coordinate: CLLocationCoordinate2D){
        self.name = name;
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = coordinate;
        self.geolocationID = geolocationID;
        super.init();
    }

    convenience init(name: String, title: String? = nil, subtitle: String? = nil, geolocationID: Int, latitude: Double, longitude: Double){
        let CLLoc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        self.init(name: name, title: title, subtitle: subtitle, geolocationID: geolocationID, coordinate: CLLoc);
    }
    
    convenience override init(){
        let CLLoc = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        self.init(name: "", geolocationID: 0, coordinate: CLLoc);
    }
}