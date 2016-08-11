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
        
    }
    
    internal func setUser(JSON: [String: AnyObject]){
        
    }
}