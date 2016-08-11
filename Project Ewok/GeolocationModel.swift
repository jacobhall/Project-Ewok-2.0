//
//  GeolocationModel.swift
//  Project Ewok
//
//  Created by asap on 8/11/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class GeolocationModel{
    //Properties
    let geolocationID: Int;
    var latitude: Double;
    var longitude: Double;
    var name: String?;
    var description: String?;
    var locationID: Int?;
    var locationType: String?;
    
    //Constructors
    init(geolocationID: Int, latitude: Double, longitude: Double, name: String? = nil, description: String? = nil, locationID: Int? = nil, locationType: String? = nil){
        self.geolocationID = geolocationID;
        self.latitude = latitude;
        self.longitude = longitude;
        self.name = name;
        self.description = description;
        self.locationID = locationID;
        self.locationType = locationType;
    }
    
    //Functions
}