//
//  UserModel.swift
//  Project Ewok
//
//  Created by asap on 8/10/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class UserModel{
    //Properties
    let userID: Int;                            //The user's ID in the DB
    var firstName: String?;                     //The first name of the user (duh)
    var lastName: String?;                      //The last name of the user (duh)
    var email: String;                          //The email of the user
    var reviews: [ReviewModel]?;                //The reviews for the user. CAN BE NULL. Set with the authenticator
    var geolocations: [GeolocationModel]?;      //The geolocations the user has validated or created. Can only be set by the authenticator
    
    //Constructors
    init(userID: Int, firstName: String? = nil, lastName: String? = nil, email: String, reviews: [ReviewModel]? = nil, geolocations: [GeolocationModel]? = nil){
        self.userID = userID;
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
    }
    
    //Functions
    internal func getReviews(){
        //POST: pulls all the reviews that is associated with the user
        reviews = nil;
        let interface = ApiInterface();
        interface.onCompleteWithReturns = setReviews;
        interface.getReviews(userID: userID);
    }
    
    internal func setReviews(returns: AnyObject){
        //PRE: requires JSON from a request
        //POST: creates an array of reviews and places them in self.reviews. This may be empty.
        if let reviewModels = returns as? [ReviewModel] {
            reviews = reviewModels;
        }
    }
    
    //No function is included for getGeolocations because it is not possible with the current API
}