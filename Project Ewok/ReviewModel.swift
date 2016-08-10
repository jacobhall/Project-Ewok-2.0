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
    let reviewID: Int;
    let userID: Int;
    let geolocationID: Int;
    var rating: Int;
    var comment: String?;
    
    //Constructors
    init(reviewID: Int, userID: Int, geolocationID: Int, rating: Int, comment: String? = nil){
        self.reviewID = reviewID;
        self.userID = userID;
        self.geolocationID = geolocationID;
        self.rating = rating;
        self.comment = comment;
    }
    
    //Functions
}