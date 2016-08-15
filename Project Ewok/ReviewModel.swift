//
//  ReviewModel.swift
//  Project Ewok
//
//  Created by asap on 8/10/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class ReviewModel{
    //Properties
    let reviewID: Int;              //The review's ID in the DB
    let userID: Int;                //The owner of the review
    let geolocationID: Int;         //The geolocation for the review
    var rating: Int;                //The rating of the review
    var comment: String?;           //The comment of the geolocation by the user
    var user: UserModel?;           //The user of the review
    var geolocation: GeolocationModel?;     //The geolocation of the review
    
    //Constructors
    init(reviewID: Int, userID: Int, geolocationID: Int, rating: Int, comment: String? = nil){
        self.reviewID = reviewID;
        self.userID = userID;
        self.geolocationID = geolocationID;
        self.rating = rating;
        self.comment = comment;
    }
    
    //Functions
    internal func getUser(){
        //POST: Gets the user of the review and stores it in the user variable
        user = nil;
        let requester = RequestMaker(method: "GET", url: "users/" + String(userID));
        requester.run(setUser);
    }
    
    internal func setUser(JSON: [String: AnyObject]){
        //PRE: A user JSON from the API
        //POST: Creates a user model and sets it to user
        if let userJSON = JSON["user"] as! [String: AnyObject]!{
            let returnedUserID = userJSON["userID"] as! Int;
            let firstName = userJSON["firstName"] as! String;
            let lastName = userJSON["lastName"] as! String;
            let email = userJSON["email"] as! String;
            user = UserModel(userID: returnedUserID, firstName: firstName, lastName: lastName, email: email, reviews: nil, geolocations: nil);
        }
    }
    
    internal func getGeolocation(){
        //POST: Gets the geolocation and stores it in the geolocation variable
        geolocation = nil;
        let requester = RequestMaker(method: "GET", url: "geolocations/" + String(geolocationID), data: "GeoJSON=0");
        requester.run(setGeolocation);
    }
    
    internal func setGeolocation(JSON: [String: AnyObject]){
        //PRE: A geolocation JSON from the API
        //POST: Creates a geolocation model and sets it to geolocation 
        if let geolocationJSON = JSON["geolocation"] as! [String: AnyObject]! {
            let geolocationID = geolocationJSON["geolocationID"] as! Int;
            let latitude = (geolocationJSON["latitude"] as! NSString).doubleValue;
            let longitude = (geolocationJSON["longitude"] as! NSString).doubleValue;
            let name = geolocationJSON["name"] as! String;
            let description = geolocationJSON["description"] as? String;
            let locationID = geolocationJSON["location_id"] as? Int;
            let locationType = geolocationJSON["location_type"] as? String;
            geolocation = GeolocationModel(geolocationID: geolocationID, latitude: latitude, longitude: longitude, name: name, description: description, locationID: locationID, locationType: locationType);
        }
    }
}