//
//  Authentication.swift
//  Project Ewok
//
//  Created by asap on 8/8/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

//Class-independent constants
let TokenKey = "token";

public class Authenticator{
    //Properties
    var token: String;
    
    //Constants
    //let BaseURL = "http://chitna.asap.um.maine.edu/projectcrowdsource/public/api/";
    let BaseURL = NSURL(string: "http://chitna.asap.um.maine.edu/projectcrowdsource/public/api/");
    
    //Constructors
    init(_ token: String){
        self.token = token;
    }
    
    convenience init(){
        let defaults = NSUserDefaults.standardUserDefaults();
        let storedToken: String! = defaults.objectForKey(TokenKey) as! String!;
        if(storedToken != nil){
            self.init(storedToken);
        }
        else{
            self.init("");
        }
    }
    
    //Functions
    public func attempt(email: String, _ password: String) {
        
    }
}