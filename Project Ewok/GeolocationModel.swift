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
    let geolocationID: Int;         //The geolocation's ID
    var latitude: Double;           //The latitude of the geolocation
    var longitude: Double;          //The longitude of the geolocation
    var name: String;              //The name of the geolocation
    var description: String?;       //The description of the geolocation
    var locationID: Int?;           //The id of the location attached to the geolocation
    var locationType: String?;      //The type of the location, which is the FILEPATH!!! NOT THE ACTUAL THING!!!
    //var location: [Location]?;    //Need to be implementated
    
    //Constructors
    init(geolocationID: Int, latitude: Double, longitude: Double, name: String, description: String? = nil, locationID: Int? = nil, locationType: String? = nil){
        self.geolocationID = geolocationID;
        self.latitude = latitude;
        self.longitude = longitude;
        self.name = name;
        self.description = description;
        self.locationID = locationID;
        self.locationType = locationType;
    }
    
    //Functions
    internal func createAnnotation() -> mapAnnotation {
        //POST: Takes the data of the geolocation and creates an annotation from it
        return mapAnnotation(name: name, title: name, latitude: latitude, longitude: longitude)
    }
}