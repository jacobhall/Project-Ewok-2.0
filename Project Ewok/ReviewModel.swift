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
        let interface = ApiInterface();
        interface.onCompleteWithReturns = setUser;
        interface.getUser(userID);
    }
    
    internal func setUser(returns: AnyObject){
        //PRE: A user JSON from the API
        //POST: Creates a user model and sets it to user
        if let userModel = returns as? UserModel {
            user = userModel;
        }
    }
    
    internal func getGeolocation(){
        //POST: Gets the geolocation and stores it in the geolocation variable
        let interface = ApiInterface();
        interface.onCompleteWithReturns = setGeolocation;
        interface.getGeolocation(geolocationID);
    }
    
    internal func setGeolocation(returns: AnyObject){
        //PRE: A geolocation JSON from the API
        //POST: Creates a geolocation model and sets it to geolocation 
        if let geolocationModel = returns as? GeolocationModel {
            geolocation = geolocationModel;
        }
    }
}