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
    var name: String;               //The name of the geolocation
    var description: String?;       //The description of the geolocation
    var locationID: Int?;           //The id of the location attached to the geolocation
    var locationType: String?;      //The type of the location, which is the FILEPATH!!! NOT THE ACTUAL THING!!!
    var reviews: [ReviewModel]?;    //The reviews of the geolocation
    var pictures: [PictureModel]?;  //The pictures of the geolocation
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
    internal func getReviews(){
        //POST: sets the reviews to an array of corresponding review models
        reviews = nil;
        let requester = RequestMaker(method: "GET", url: "reviews", data: "geolocationID=" + String(geolocationID));
        requester.run(setReviews);
    }
    
    internal func setReviews(JSON: [String: AnyObject]){
        //PRE: A JSON created by a request
        //POST: sets reviews to an array of review models, created from the JSON
        if let reviewsJSON = JSON["reviews"] as! NSArray! {
            var reviewArray = [ReviewModel]();
            for reviewJSON in reviewsJSON {
                let reviewID = reviewJSON["reviewID"] as! Int;
                let userID = (reviewJSON["userID"] as! NSString).integerValue;
                let comment = reviewJSON["comment"] as? String;
                let rating = (reviewJSON["rating"] as! NSString).integerValue;
                let geolocationID = (reviewJSON["geolocationID"] as! NSString).integerValue;
                let review = ReviewModel(reviewID: reviewID, userID: userID, geolocationID: geolocationID, rating: rating, comment: comment);
                reviewArray.append(review);
            }
            reviews = reviewArray;
        }
        else{
            reviews = [ReviewModel]();
        }
    }
    
    internal func getPictures(){
        pictures = nil;
        let requester = RequestMaker(method: "GET", url: "pictures", data: "ID=" + String(geolocationID) + "&model=geolocation");
        requester.run(setPictures);
    }
    
    internal func setPictures(JSON: [String: AnyObject]){
        if let picturesJSON = JSON["pictures"] as! NSArray! {
            var pictureArray = [PictureModel]();
            for pictureJSON in picturesJSON {
                let pictureID = pictureJSON["pictureID"] as! Int;
                var attachedType = pictureJSON["attached_type"] as! String;
                attachedType = attachedType.substringFromIndex(attachedType.startIndex.advancedBy(4));
                let attachedID = (pictureJSON["attached_id"] as! NSString).integerValue;
                let filePath = pictureJSON["filePath"] as! String;
                let picture = PictureModel(pictureID: pictureID, attachedModel: attachedType, attachedID: attachedID, filePath: filePath);
                pictureArray.append(picture);
            }
            pictures = pictureArray;
        }
        else{
            pictures = [PictureModel]();
        }
    }
    
    //GET USERS DOES NOT EXIST BC OF API INABILITY TO PROCESS
    
    internal func createAnnotation() -> mapAnnotation {
        //POST: Takes the data of the geolocation and creates an annotation from it
        return mapAnnotation(name: name, title: name, latitude: latitude, longitude: longitude)
    }
}