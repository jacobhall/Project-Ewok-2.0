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
    let userID: Int;
    var firstName: String?;
    var lastName: String?;
    var email: String;
    var reviews: [ReviewModel]?;
    
    //Constructors
    init(userID: Int, firstName: String? = nil, lastName: String? = nil, email: String){
        self.userID = userID;
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
    }
    
    //Functions
    internal func getReviews(){
        //POST: pulls all the reviews that is associated with the user
        let requester = RequestMaker(method: "GET", url: "reviews", data: "userID="+String(userID));
        requester.run(setReviews);
    }
    
    internal func setReviews(JSON: [String: AnyObject]){
        let reviewsJSON = JSON["reviews"] as! NSArray;
        reviews = [ReviewModel]();
        for reviewJSON in reviewsJSON{
            let reviewID = reviewJSON["reviewID"] as! Int;
            let reviewUserID = (reviewJSON["userID"] as! NSString).integerValue;
            let comment = reviewJSON["comment"] as! String?;
            let rating = (reviewJSON["rating"] as! NSString).integerValue;
            let geolocationID = (reviewJSON["geolocationID"] as! NSString).integerValue;
            let review = ReviewModel(reviewID: reviewID, userID: reviewUserID, geolocationID: geolocationID, rating: rating,  comment: comment);
            reviews!.append(review);
        }
    }
}