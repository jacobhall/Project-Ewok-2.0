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
     createNewReview = GeolocationModel
     updateGeolocation = NONE
     validateGeolocation = NONE
     */
    //Properties
    var returns: AnyObject?;
    var completed: Bool?;
    var requester: RequestMaker!;
    let auth = Authenticator.sharedInstance;
    
    //Constructors
    init(){
        
    }
    
    //Functions
    internal func setCompleted(){
        self.completed = true;
    }
    
    internal func getRawGeolocations(radius: Int? = nil, latitude: Double? = nil, longitude: Double? = nil, unit: String? = nil, locationType: String? = nil, name: String? = nil, operatingTime: String? = nil) {
        //PRE: Any of the options above are optional but, if radius is set, so must latitude and longitude
        //POST: sets returns to the raw GeoJSON. Useful when using a mapping application like Google Maps
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
        var geolocations = [GeolocationModel]()
        for geolocationJSON in geolocationsJSON {
            let geolocationID = geolocationJSON["geolocationID"] as! Int;
            let latitude = (geolocationJSON["latitude"] as! NSString).doubleValue;
            let longitude = (geolocationJSON["longitude"] as! NSString).doubleValue;
            let name = geolocationJSON["name"] as! String;
            let description = geolocationJSON["description"] as? String;
            let locationID = geolocationJSON["location_id"] as? Int;
            let locationType = geolocationJSON["location_type"] as? String;
            let geolocation = GeolocationModel(geolocationID: geolocationID, latitude: latitude, longitude: longitude, name: name, description: description, locationID: locationID, locationType: locationType)
            geolocations.append(geolocation);
        }
        returns = geolocations;
        completed = true;
    }
    
    internal func getGeolocation(geolocationID: Int){
        //PRE: The geolocationID must match an geolocationID in the database
        //POST: creates a request and sets the results to the geolocation as a model
        returns = nil;
        completed = false;
        requester = RequestMaker(method: "GET", url: "geolocations/" + String(geolocationID), data: "GeoJSON=0");
        requester.run(setGeolocation);
    }
    
    internal func setGeolocation(JSON: [String: AnyObject]){
        //PRE: takes a JSON from a request maker
        //POST: sets results to the geolocation object
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
    
    internal func updateGeolocation(geolocation: GeolocationModel, submitterLatitude: Double, submitterLongitude: Double){
        //PRE: A geolocation model to update must be provided. This model must already exist in the database. The submitter's location cannot be more than half a mile away.
        //POST: Updates the geolocation in the database with the model. Any errors will be contained in the requester.
        returns = nil;
        completed = false;
        var dataString = "latitude=" + String(geolocation.latitude) + "&longitude=" + String(geolocation.longitude) + "&name=" + geolocation.name + "submitterLatitude=" + String(submitterLatitude) + "submitterLongitude" + String(submitterLongitude);
        if(geolocation.description != nil){
            dataString += "&description=" + geolocation.description!;
        }
        requester = RequestMaker(method: "PUT", url: "geolocations/" + String(geolocation.geolocationID), data: dataString);
        if(auth.token != nil){
            requester.authorize(auth.token!);
        }
        requester.run(setCompleted);
    }
    
    internal func validateLocation(geolocation: GeolocationModel, submitterLatitude: Double, submitterLongitude: Double, valid: Bool){
        //PRE: A geolocation model to update must be provided. This model must already exist in the database. The submitter's location cannot be more than half a mile away.
        //POST: Validates the location on behalf of the user. If more than 50% of validations report invalid, destroys the geolocation.
        returns = nil;
        completed = false;
        let dataString = "valid=" + String(Int(valid)) + "&submitterLatitude=" + String(submitterLatitude) + "&submitterLongitude=" + String(submitterLongitude);
        requester = RequestMaker(method: "POST", url: "geolocations/" + String(geolocation.geolocationID), data: dataString);
        if(auth.token != nil){
            requester.authorize(auth.token!);
        }
        requester.run(setCompleted);
    }
    
    internal func getReviews(geolocationID: Int? = nil, userID: Int? = nil){
        //PRE: both geolocationID and userID can be used to narrow the search
        //POST: makes a request based on the above and sets reviews to an array of review models
        returns = nil;
        completed = false;
        var dataString = "";
        if(geolocationID != nil){
            dataString += "&geolocationID=" + String(geolocationID);
        }
        if(userID != nil){
            dataString += "&userID=" + String(userID);
        }
        if(dataString.isEmpty){
            requester = RequestMaker(method: "GET", url: "reviews");
        }
        else{
            dataString = dataString.substringFromIndex(dataString.startIndex.advancedBy(2));
            requester = RequestMaker(method: "GET", url: "reviews", data: dataString);
        }
        requester.run(setReviews);
    }
    
    internal func setReviews(JSON: [String: AnyObject]){
        //PRE: A JSON created by a request
        //POST: sets returns to an array of reviews, created from the JSON
        if let reviewsJSON = JSON["reviews"] as! NSArray! {
            var reviews = [ReviewModel]();
            for reviewJSON in reviewsJSON {
                let reviewID = reviewJSON["reviewID"] as! Int;
                let userID = (reviewJSON["userID"] as! NSString).integerValue;
                let comment = reviewJSON["comment"] as? String;
                let rating = (reviewJSON["rating"] as! NSString).integerValue;
                let geolocationID = (reviewJSON["geolocationID"] as! NSString).integerValue;
                let review = ReviewModel(reviewID: reviewID, userID: userID, geolocationID: geolocationID, rating: rating, comment: comment);
                reviews.append(review);
            }
            returns = reviews;
        }
        else{
            returns = [ReviewModel]();
        }
        completed = true;
    }
    
    internal func getReview(reviewID: Int){
        //PRE: reviewID must match a reviewID in the database
        //POST: makes a request and sets returns to a specific review model
        returns = nil;
        completed = false;
        requester = RequestMaker(method: "GET", url: "reviews/" + String(reviewID));
        requester.run(setReview);
    }
    
    internal func setReview(JSON: [String: AnyObject]){
        //PRE: A JSON created by a request
        //POST: sets the returns to a review model, created from the JSON
        if let reviewJSON = JSON["review"] as! [String: AnyObject]! {
            let reviewID = reviewJSON["reviewID"] as! Int;
            let userID = (reviewJSON["userID"] as! NSString).integerValue;
            let comment = reviewJSON["comment"] as? String;
            let rating = (reviewJSON["rating"] as! NSString).integerValue;
            let geolocationID = (reviewJSON["geolocationID"] as! NSString).integerValue;
            let review = ReviewModel(reviewID: reviewID, userID: userID, geolocationID: geolocationID, rating: rating, comment: comment);
            returns = review;
        }
        else{
            returns = nil;
        }
        completed = true;
    }
    
    internal func createNewReview(geolocationID: Int, rating: Int, comment: String? = nil){
        returns = nil;
        completed = nil;
        var dataString = "geolocationID=" + String(geolocationID) + "&rating=" + String(rating);
        if(comment != nil){
            dataString += "&comment=" + comment!;
        }
        requester = RequestMaker(method: "POST", url: "reviews", data: dataString);
    }
}