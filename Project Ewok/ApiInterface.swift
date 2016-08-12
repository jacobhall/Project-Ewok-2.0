//
//  ApiInterface.swift
//  Project Ewok
//
//  Created by asap on 8/11/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class ApiInterface{
    /**
     Basic usage:
     
     This class is used to interface with the API and create models in the application.
     
     You can make this class anywhere and it has absolutely no overhead
     
     When you need something, call one of the "get" functions within this class.
     This will get data from the database and create what you need. When completed,
     returns will contain the data requested.
     
     If you need to wait for the operation to complete, completed will be set to
     true upon process completion.
     
     Make sure that, when you are obtaining a returns, cast it to the right type.
     
     The return types are as follows;
     getGeolocations = [GeolocationModel]
     getGeolocation = GeolocationModel
     */
    //Properties
    var returns: AnyObject?;
    var completed: Bool?;
    var requester: RequestMaker!;
    
    //Constructors
    init(){
        
    }
    
    //Functions
    internal func getRawGeolocations(radius: Int? = nil, latitude: Double? = nil, longitude: Double? = nil, unit: String? = nil, locationType: String? = nil, name: String? = nil, operatingTime: String? = nil) {
        //PRE: Any of the options above are optional but, if radius is set, so must latitude and longitude
        //POST: sets returns to the raw GeoJSON
        returns = nil;
        completed = false;
        var dataString = "";
        if(radius != nil){
            dataString += "&radius=" + String(radius!);
            dataString += "&latitude=" + String(latitude!);
            dataString += "&longitude=" + String(longitude!);
            if(unit != nil){
                dataString += "&unit=" + unit!;
            }
        }
        if(locationType != nil){
            dataString += "&locationType=" + locationType!;
        }
        if(name != nil){
            dataString += "&name=" + name!;
        }
        if(operatingTime != nil){
            dataString += "&operatingTime=" + operatingTime!;
        }
        dataString += "&GeoJSON=" + String(1);
        if(!dataString.isEmpty){
            dataString = dataString.substringFromIndex(dataString.startIndex.advancedBy(2));
            requester = RequestMaker(method: "GET", url: "geolocations", data: dataString);
            requester.run(setRawGeolocations);
        }
    }
    
    internal func setRawGeolocations(JSON: [String: AnyObject]){
        //POST: sets returns to the raw GeoJSON returned from the request IF there are no errors
        //      if there is an error, returns is set to an empty array
        if(requester.error == nil && JSON["message"] == nil && JSON["error"] == nil){
            returns = JSON;
        }
        else{
            returns = [];
        }
    }
    
    internal func getGeolocations(radius: Int? = nil, latitude: Double? = nil, longitude: Double? = nil, unit: String? = nil, locationType: String? = nil, name: String? = nil, operatingTime: String? = nil){
        //PRE: Any of the options above are optional but, if radius is set, so must latitude and longitude
        //POST: runs the request and sets the returns value above to an array of geolocations
        returns = nil;
        completed = false;
        var dataString = "";
        if(radius != nil){
            dataString += "&radius=" + String(radius!);
            dataString += "&latitude=" + String(latitude!);
            dataString += "&longitude=" + String(longitude!);
            if(unit != nil){
                dataString += "&unit=" + unit!;
            }
        }
        if(locationType != nil){
            dataString += "&locationType=" + locationType!;
        }
        if(name != nil){
            dataString += "&name=" + name!;
        }
        if(operatingTime != nil){
            dataString += "&operatingTime=" + operatingTime!;
        }
        dataString += "&GeoJSON=" + String(0);
        if(!dataString.isEmpty){
            dataString = dataString.substringFromIndex(dataString.startIndex.advancedBy(2));
            requester = RequestMaker(method: "GET", url: "geolocations", data: dataString);
            requester.run(setGeolocations);
        }
    }
    
    internal func setGeolocations(JSON: [String: AnyObject]){
        //PRE: A JSON array with a "geolocations" component
        //POST: Creates a array of geolocations from the database and sets it to returns
        let geolocationsJSON = JSON["geolocations"] as! NSArray
        var returnValue = [GeolocationModel]()
        for geolocationJSON in geolocationsJSON {
            let geolocationID = geolocationJSON["geolocationID"] as! Int;
            let latitude = (geolocationJSON["latitude"] as! NSString).doubleValue;
            let longitude = (geolocationJSON["longitude"] as! NSString).doubleValue;
            let name = geolocationJSON["name"] as! String;
            let description = geolocationJSON["description"] as? String;
            let locationID = geolocationJSON["location_id"] as? Int;
            let locationType = geolocationJSON["location_type"] as? String;
            let geolocation = GeolocationModel(geolocationID: geolocationID, latitude: latitude, longitude: longitude, name: name, description: description, locationID: locationID, locationType: locationType)
            returnValue.append(geolocation);
        }
        returns = returnValue;
        completed = true;
    }
    
    internal func getGeolocation(geolocationID: Int){
        returns = nil;
        completed = false;
        requester = RequestMaker(method: "GET", url: "geolocations/" + String(geolocationID), data: "GeoJSON=0");
        requester.run(setGeolocation);
    }
    
    internal func setGeolocation(JSON: [String: AnyObject]){
        let geolocationJSON = JSON["geolocation"] as! [String: AnyObject];
        let geolocationID = geolocationJSON["geolocationID"] as! Int;
        let latitude = (geolocationJSON["latitude"] as! NSString).doubleValue;
        let longitude = (geolocationJSON["longitude"] as! NSString).doubleValue;
        let name = geolocationJSON["name"] as! String;
        let description = geolocationJSON["description"] as? String;
        let locationID = geolocationJSON["location_id"] as? Int;
        let locationType = geolocationJSON["location_type"] as? String;
        let geolocation = GeolocationModel(geolocationID: geolocationID, latitude: latitude, longitude: longitude, name: name, description: description, locationID: locationID, locationType: locationType)
        returns = geolocation;
        completed = true;
    }
    
    internal func createNewGeolocation(latitude latitude: Double, longitude: Double, submitterLatitude: Double, submitterLongitude: Double, name: String, description: String? = nil, locationID: Int? = nil, locationType: String? = nil, token: String? = nil) {
        //PRE: latitude, submitterLatitude, longitude, and submitterLongitude must be doubles. Coordinates must be within half a mile of eachother. Name must be a string.
        //POST: creates the location in the DB
        returns = nil;
        completed = false;
        var dataString = "latitude=" + String(latitude) + "&longitude=" + String(longitude) + "&name=" + name + "&submitterLatitude=" + String(submitterLatitude) + "&submitterLongitude=" + String(submitterLongitude);
        if (description != nil){
            dataString += "&description=" + description!;
        }
        if(locationID != nil){
            dataString += "&locationID=" + String(locationID!);
        }
        if(locationType != nil){
            dataString += "&locationType=" + locationType!;
        }
        requester = RequestMaker(method: "POST", url: "geolocations", data: dataString);
        if (token == nil){
            let auth = Authenticator.sharedInstance;
            if(auth.token != nil){
                requester.authorize(auth.token!);
            }
        }
        else{
            requester.authorize(token!);
        }
        requester.run(getGeolocationAfterCreation);
    }
    
    internal func getGeolocationAfterCreation(JSON: [String: AnyObject]){
        if let geolocationID = JSON["ID"] as? Int {
            getGeolocation(geolocationID);
        }
        else{
            //TO DO: ERROR PROMPTS
            print(requester.error);
        }
    }
}