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
    
    //Constructors
    init(userID: Int, firstName: String? = nil, lastName: String? = nil, email: String){
        self.userID = userID;
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
    }
    
    //Functions
}