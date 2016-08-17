//
//  PictureModel.swift
//  Project Ewok
//
//  Created by asap on 8/12/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class PictureModel {
    //Properties
    let pictureID: Int;         //The ID in the database
    let attachedModel: String;  //The model this is attached to
    let attachedID: Int;        //The ID of the model this is attached to
    var filePath: String;       //The filePath. DO NOT LET VAR DECEIVE YOU; YOU SHOULD NOT CHANGE THIS MANUALLY!
    var attached: AnyObject?;
    
    //Constructors
    init(pictureID: Int, attachedModel: String, attachedID: Int, filePath: String){
        self.pictureID = pictureID;
        self.attachedID = attachedID;
        self.attachedModel = attachedModel;
        self.filePath = filePath;
    }
    
    //Functions
    internal func getAttached(){
        //POST: sets attached to the object the picture is attached to
        //NOTE: DOES NOT WORK FOR USERS
        attached = nil;
        let requester = RequestMaker(method: "GET", url: attachedModel + "s/" + String(attachedID));
        requester.run(setAttached);
    }
    
    internal func setAttached(JSON: [String: AnyObject]){
        //PRE: A JSON from the show route of the attached model
        //POST: sets attached to the corresponding object
        if let geolocationJSON = JSON["geolocation"] as! [String: AnyObject]! {
            let geolocationID = geolocationJSON["geolocationID"] as! Int;
            let latitude = (geolocationJSON["latitude"] as! NSString).doubleValue;
            let longitude = (geolocationJSON["longitude"] as! NSString).doubleValue;
            let name = geolocationJSON["name"] as! String;
            let description = geolocationJSON["description"] as? String;
            var averageRating: Double;
            if let averageRatingString = geolocationJSON["averageRating"] as? NSString! {
                averageRating = averageRatingString.doubleValue;
            }
            else{
                averageRating = geolocationJSON["averageRating"] as! Double;
            }
            let locationID = geolocationJSON["location_id"] as? Int;
            let locationType = geolocationJSON["location_type"] as? String;
            let geolocation = GeolocationModel(geolocationID: geolocationID, latitude: latitude, longitude: longitude, name: name, description: description, averageRating: averageRating, locationID: locationID, locationType: locationType)
            attached = geolocation;
        }
        else if let reviewJSON = JSON["review"] as! [String: AnyObject]! {
            let reviewID = reviewJSON["reviewID"] as! Int;
            let userID = (reviewJSON["userID"] as! NSString).integerValue;
            let comment = reviewJSON["comment"] as? String;
            let rating = (reviewJSON["rating"] as! NSString).integerValue;
            let geolocationID = (reviewJSON["geolocationID"] as! NSString).integerValue;
            let review = ReviewModel(reviewID: reviewID, userID: userID, geolocationID: geolocationID, rating: rating, comment: comment);
            attached = review;
        }
    }
}