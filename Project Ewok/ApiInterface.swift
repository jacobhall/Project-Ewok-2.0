//
//  ApiInterface.swift
//  Project Ewok
//
//  Created by asap on 8/11/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation
import UIKit

public class ApiInterface: Requester {
    /**
     Basic usage:
     
     This class is used to interface with the API and create models in the application.
     
     You can make this class anywhere and it has absolutely no overhead
     
     When you need something, call one of the "get" functions within this class.
     This will get data from the database and create what you need. When completed,
     returns will contain the data requested.
     
     If you need to wait for the operation to complete, completed will be set to
     true upon process completion.
     
     You can set onComplete or onCompleteWithReturns to call the function
     when the request has been completed. See below for explicit documentation.
     
     Make sure that, when you are obtaining a returns, cast it to the right type.
     
     The return types are as follows;
     getGeolocations = [GeolocationModel]
     getGeolocation = GeolocationModel
     createNewReview = GeolocationModel
     updateGeolocation = NONE
     validateGeolocation = NONE
     getReviews = [ReviewModel]
     getReview = ReviewModel
     createNewReview = ReviewModel
     updateReview = NONE
     destroyReview = NONE
     getPictures = [PictureModel]
     getPicture = PictureModel or NONE (See function comments)
    */
    //Properties
    var returns: AnyObject?;                                //The return value of the function
    var onCompleteWithReturns: ((AnyObject) -> Void)?;      //The completion handler for returns, if need be
    let auth = Authenticator.sharedInstance;                //The authenticator to authorize requests
    
    //Constructors
    override init(){
        super.init();
    }
    
    //Functions
    override internal func setCompleted(){
        //POST: sets complete to true and runs any completion handlers
        if(onCompleteWithReturns != nil && returns != nil){
            onCompleteWithReturns!(returns!);
        }
        if(onComplete != nil){
            onComplete!();
        }
        completed = true;
    }
    
    /////////////////////////
    /////////////////////////
    //////////USERS//////////
    /////////////////////////
    /////////////////////////
    internal func getUser(userID: Int){
        //POST: Gets the user of the review and stores it in the user variable
        returns = nil;
        completed = false;
        requester = RequestMaker(method: "GET", url: "users/" + String(userID));
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
            returns = UserModel(userID: returnedUserID, firstName: firstName, lastName: lastName, email: email, reviews: nil, geolocations: nil);
        }
        setCompleted();
    }
    
    ////////////////////////////////
    ////////////////////////////////
    ////////////////////////////////
    //////////GEOLOCATIONS//////////
    ////////////////////////////////
    ////////////////////////////////
    ////////////////////////////////
    internal func getRawGeolocations(radius: Int? = nil, latitude: Double? = nil, longitude: Double? = nil, unit: String? = nil, locationType: String? = nil, name: String? = nil, operatingTime: String? = nil) {
        //PRE: Any of the options above are optional but, if radius is set, so must latitude and longitude
        //      The operating time format is HH:MM:SS
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
            dataString = dataString.substringFromIndex(dataString.startIndex.advancedBy(1));
            requester = RequestMaker(method: "GET", url: "geolocations", data: dataString);
            requester.run(setRawGeolocations);
        }
    }
    
    internal func setRawGeolocations(JSON: [String: AnyObject]){
        //POST: sets returns to the raw GeoJSON returned from the request IF there are no errors
        //      if there is an error, returns is set to an empty array
        if(requester.error == nil && JSON["message"] == nil && JSON["error"] == nil){
            returns = JSON;
            setCompleted();
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
        dataString = dataString.substringFromIndex(dataString.startIndex.advancedBy(1));
        requester = RequestMaker(method: "GET", url: "geolocations", data: dataString);
        requester.run(setGeolocations);
    }
    
    internal func setGeolocations(JSON: [String: AnyObject]){
        //PRE: A JSON array with a "geolocations" component
        //POST: Creates a array of geolocations from the database and sets it to returns
        if let geolocationsJSON = JSON["geolocations"] as! NSArray! {
            var geolocations = [GeolocationModel]()
            for geolocationJSON in geolocationsJSON {
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
                geolocations.append(geolocation);
            }
            returns = geolocations;
        }
        setCompleted();
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
            returns = geolocation;
        }
        setCompleted();
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
            setCompleted();
        }
    }
    
    internal func updateGeolocation(geolocationModel geolocation: GeolocationModel, submitterLatitude: Double, submitterLongitude: Double){
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
    
    ///////////////////////////
    ///////////////////////////
    //////////REVIEWS//////////
    ///////////////////////////
    ///////////////////////////
    internal func getReviews(geolocationID: Int? = nil, userID: Int? = nil){
        //PRE: both geolocationID and userID can be used to narrow the search
        //POST: makes a request based on the above and sets reviews to an array of review models
        returns = nil;
        completed = false;
        var dataString = "";
        if(geolocationID != nil){
            dataString += "&geolocationID=" + String(geolocationID!);
        }
        if(userID != nil){
            dataString += "&userID=" + String(userID!);
        }
        if(dataString.isEmpty){
            requester = RequestMaker(method: "GET", url: "reviews");
        }
        else{
            dataString = dataString.substringFromIndex(dataString.startIndex.advancedBy(1));
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
        setCompleted();
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
        setCompleted();
    }
    
    internal func createNewReview(geolocationID geolocationID: Int, rating: Int, comment: String? = nil){
        //PRE: geolocationID must match a geolocation in the DB. rating must be between 0 and 5.
        //POST: creates a geolocation in the database and sets returns to it
        returns = nil;
        completed = false;
        var dataString = "geolocationID=" + String(geolocationID) + "&rating=" + String(rating);
        if(comment != nil){
            dataString += "&comment=" + comment!;
        }
        requester = RequestMaker(method: "POST", url: "reviews", data: dataString);
        if(auth.token != nil){
            requester.authorize(auth.token!);
        }
        requester.run(getReviewAfterCreated);
    }
    
    internal func getReviewAfterCreated(JSON: [String: AnyObject]){
        //PRE: a JSON from a creation request
        //POST: passes the ID to getReview
        if let reviewID = JSON["ID"] as? Int {
            getReview(reviewID);
        }
        else{
            setCompleted();
        }
    }
    
    internal func updateReview(review: ReviewModel){
        //PRE: a ReviewModel obtains from the DB
        //POST: updates the review with the changed information in the DB
        returns = nil;
        completed = false;
        var dataString = "rating=" + String(review.rating);
        if(review.comment != nil){
            dataString += "&comment=" + review.comment!;
        }
        requester = RequestMaker(method: "PUT", url: "reviews/" + String(review.reviewID), data: dataString);
        if(auth.token != nil){
            requester.authorize(auth.token!);
        }
        requester.run(setCompleted);
    }
    
    internal func destroyReview(review: ReviewModel){
        //PRE: a ReviewModel obtained from the DB
        //POST: destroys the review in the DB
        returns = nil;
        completed = false;
        requester = RequestMaker(method: "DELETE", url: "reviews/" + String(review.reviewID));
        if(auth.token != nil){
            requester.authorize(auth.token!);
        }
        requester.run(setCompleted);
    }
    
    ////////////////////////////
    ////////////////////////////
    //////////PICTURES//////////
    ////////////////////////////
    ////////////////////////////
    internal func getPictures(ID: Int? = nil, model: String? = nil){
        //PRE: ID and model can narrow your search
        //POST: creates a request and sets returns to an array of pictures using setPictures
        returns = nil;
        completed = false;
        var dataString = "";
        if(ID != nil){
            dataString += "&id=" + String(ID!);
        }
        if(model != nil){
            dataString += "&model=" + String(model!);
        }
        if(dataString.isEmpty){
            requester = RequestMaker(method: "GET", url: "pictures");
        }
        else{
            requester = RequestMaker(method: "GET", url: "pictures", data: dataString.substringFromIndex(dataString.startIndex.advancedBy(1)));
        }
        requester.run(setPictures);
    }
    
    internal func setPictures(JSON: [String: AnyObject]){
        //PRE: A JSON returned from a picture index
        //POST: creates an array of pictures and sets returns to it
        if let picturesJSON = JSON["pictures"] as! NSArray! {
            var pictures = [PictureModel]();
            for pictureJSON in picturesJSON {
                let pictureID = pictureJSON["pictureID"] as! Int;
                var attachedType = pictureJSON["attached_type"] as! String;
                attachedType = attachedType.substringFromIndex(attachedType.startIndex.advancedBy(4));
                let attachedID = (pictureJSON["attached_id"] as! NSString).integerValue;
                let filePath = pictureJSON["filePath"] as! String;
                let picture = PictureModel(pictureID: pictureID, attachedModel: attachedType, attachedID: attachedID, filePath: filePath);
                pictures.append(picture);
            }
            returns = pictures;
        }
        setCompleted();
    }
    
    internal func getPicture(pictureID: Int, model: Bool = false, completion: ((NSData) -> Void)? = nil){
        //PRE: The pictureID must match a picture's ID in the DB. A completion may be provided to act upon the NSData of the picture provided. The model bool controls whether you will get the picture data or the model data. It is set to false by default.
        //POST: creates a request and runs the request. If a completion handler is provided, it will use that completion handler. Otherwise, it will set the returns to a picture model.
        returns = nil;
        completed = false;
        let dataString = "model=" + String(Int(model));
        requester = RequestMaker(method: "GET", url: "pictures/" + String(pictureID), data: dataString);
        if(completion == nil){
            requester.run(setPicture);
        }
        else {
            requester.run(completion!);
            setCompleted();
        }
    }
    
    internal func getPicture(itemID itemID: Int, model: String, completion: ((NSData) -> Void)? = nil){
        returns = nil;
        completed = false;
        let dataString = "id=" + String(itemID) + "&model=" + model;
        requester = RequestMaker(method: "GET", url: "firstPicture", data: dataString);
        if(completion == nil){
            requester.run(setCompleted);
        }
        else {
            requester.run(completion!);
            setCompleted();
        }
    }
    
    internal func setPicture(JSON: [String: AnyObject]){
        //PRE: A picture JSON from a request
        //POST: creates a picture model from the JSON
        if let pictureJSON = JSON["picture"] as! [String: AnyObject]! {
            let pictureID = pictureJSON["pictureID"] as! Int;
            var attachedType = pictureJSON["attached_type"] as! String;
            attachedType = attachedType.substringFromIndex(attachedType.startIndex.advancedBy(4));
            let attachedID = (pictureJSON["attached_id"] as! NSString).integerValue;
            let filePath = pictureJSON["filePath"] as! String;
            let picture = PictureModel(pictureID: pictureID, attachedModel: attachedType, attachedID: attachedID, filePath: filePath);
            returns = picture;
        }
        setCompleted();
    }
    
    internal func createNewPicture(image image: UIImage, attachedModel: String, attachedID: Int, getModel: Bool = false){
        //PRE: An image, attached model, attached ID must ALL BE PROVIDED. getModel will return the picture model at the end, if desired.
        //POST: puts the picture in PNG format into the database.
        returns = nil;
        completed = false;
        requester = RequestMaker(method: "POST", url: "pictures");
        if(auth.token != nil){
            requester.authorize(auth.token!);
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            let boundary = "--BOUNDARY--BOUNDARY--BOUNDARY--";
            let body = NSMutableData();
            let fileName = "iOSPicture.jpg";
            let mimetype = "image/jpeg";
            
            //Creating body of request
            //Image body
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            //Model body
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"attachedModel\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!);
            body.appendData(attachedModel.dataUsingEncoding(NSUTF8StringEncoding)!);
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            //ID body
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"attachedID\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!);
            body.appendData(String(attachedID).dataUsingEncoding(NSUTF8StringEncoding)!);
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            //Adding it to the requester
            requester.request.setValue("multipart/form-data; boundary =\(boundary)", forHTTPHeaderField: "Content-Type");
            requester.request.HTTPBody = body;
            print("REQUEST MADE");
        }
        if(getModel == false){
            requester.run(setCompleted);
        }
        else{
            requester.run(getPictureAfterCreated);
        }
    }
    
    internal func getPictureAfterCreated(JSON: [String: AnyObject]){
        //PRE: a JSON from a creation request
        //POST: passes the ID to getPicture
        if let pictureID = JSON["ID"] as? Int {
            getPicture(pictureID);
        }
        else{
            setCompleted();
        }
    }
    
    internal func updatePictre(picture: PictureModel, image: UIImage){
        //PRE: A pictureModel obtained from the DB and an image
        //POST: updates the picture model in the DB with the new image. DOES NOT CHANGE ANYTHING ELSE.
        returns = nil;
        completed = false;
        requester = RequestMaker(method: "POST", url: "pictures/" + String(picture.pictureID));
        if let imageData = UIImagePNGRepresentation(image) {
            let boundary = "--BOUNDARY--BOUNDARY--BOUNDARY--";
            let body = NSMutableData();
            let fileName = "iOSPicture.jpg";
            let mimetype = "image/jpeg";
            
            //Image body
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            //Adding it to the requster
            requester.request.setValue("multipart/form-data; boundary =\(boundary)", forHTTPHeaderField: "Content-Type");
            requester.request.HTTPBody = body;
        }
        requester.run(setCompleted);
    }
}