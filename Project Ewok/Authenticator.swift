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
    /**
     Basic usage:
     create an authenticator with an init() call
     
     check if the token is set from the user defaults. If not,
     act accordingly (ask the user to log in, maybe)
     
     When logging in, use an authenticate method and
     check the requester for when it finishes. The 
     requester contains an "error" property that will be set
     if there are any errors. This also contains a "completed"
     property that will tell you when all the tasks are completed.
     
     Note that a token expires after 60 minutes but may be refreshed
     within a 2 week window.
     
     When registering, use the register method or
     the registerAndAuthenticate method (per your desire).
     Handle it otherwise like an authentication.
     
     You may refresh the token periodically to prevent the user
     from being logged out too soon.
     
     When the user logs out, destroy the token.
     
     To check if the user already has a valid token, you may call
     getUser(). User will be nil if it isn't valid or a dictionary if it is
     valid. Make sure to try to refresh the token when you do this.
     You can always call refreshAndGetUser to avoid this.
     
     Note that user may already be set! If you are using an Authenticator already
     instantiated from another place, it's quite possible that user is already calculated.
     Bear this in mind when using it.
    */
    
    //Properties
    var token: String?;             //The token
    var completed: Bool?;           //A boolean to tell when the token has been set
    var requester: RequestMaker!;   //The request
    var user: [String: AnyObject]?; //Holds user data when it is present
    var valid: Bool?                //Determines whether the token is valid
    
    //Constructors
    init(_ token: String?){
        //POST: sets the token (probably shouldn't use)
        if(token != nil){
            self.token = token!;
            self.valid = true;
        }
        else{
            self.token = nil;
            self.valid = false;
        }
    }
    
    convenience init(){
        //POST: Looks in the user's defaults to find a token. If none exists, token is null
        let defaults = NSUserDefaults.standardUserDefaults();
        let storedToken: String! = defaults.objectForKey(TokenKey) as! String!;
        if(storedToken != nil){
            self.init(storedToken);
        }
        else{
            self.init(nil);
        }
    }
    
    //Mutators
    internal func setToken(JSON: [String: AnyObject]) -> Void {
        //PRE: a JSON dictionary
        //POST: sets the token if one is found in the JSON
        //      Also saves the token to the user's defaults
        let defaults = NSUserDefaults.standardUserDefaults();
        if let token = JSON[TokenKey] as? String {
            self.token = token;
            defaults.setObject(token, forKey: TokenKey)
            self.valid = true;
        }
        else{
            self.valid = false;
        }
        self.completed = true;
    }
    
    //Functions
    internal func authenticate(email: String, _ password: String) {
        //PRE: email and password must be a matching pair in the DB
        //POST: runs an authenticate request and sets the token asychronously
        self.completed = false;
        requester = RequestMaker(method: "POST", url: "authenticate", data: "email="+email+"&password="+password);
        requester.run(setToken);
    }
    
    internal func register(email: String, password: String, confirmed: String, firstName: String, lastName: String){
        //PRE: email must be _@_._ and password must match confirmed
        //POST: runs the register request and places the user in the DB asynchronously
        self.completed = false;
        let data = "email="+email+"&password="+password+"&password_confirmation="+confirmed+"&firstName="+firstName+"&lastName="+lastName;
        requester = RequestMaker(method: "POST", url: "register", data: data);
        requester.run();
        while(requester.ready == false){
            sleep(1);
        }
        self.completed = true;
    }
    
    internal func registerAndAuthenticate(email: String, password: String, confirmed: String, firstName: String, lastName: String){
        //PRE: email must be _@_._ and password must match confirmed
        //POST: runs the register request and subsequently authenticates asychronously
        self.completed = false;
        let data = "email="+email+"&password="+password+"&password_confirmation="+confirmed+"&firstName="+firstName+"&lastName="+lastName;
        requester = RequestMaker(method: "POST", url: "register", data: data);
        requester.run();
        while(requester.ready == false){
            sleep(1);
        }
        if(requester.error == nil){
            self.authenticate(email, password);
            self.completed = true;
        }
    }
    
    internal func refreshToken(){
        //PRE: the token property must be set and valid
        //POST: destroys the old token and sets the new token to the token property asynchronously
        self.completed = false;
        requester = RequestMaker(method: "POST", url: "refreshToken");
        if(self.token != nil){
            requester.authorize(self.token!);
            requester.run(setToken);
        }
    }
    
    internal func destroyToken(){
        //PRE: the token property must be set and valid
        //POST: destroys the token so itx can no longer be used
        self.completed = false;
        self.valid = false;
        requester = RequestMaker(method: "POST", url: "destroyToken");
        if(self.token != nil){
            requester.authorize(self.token!);
            requester.run();
        }
        while(requester.ready == false){
            sleep(1);
        }
        self.completed = true;
    }
    
    internal func getUser(){
        //PRE: the token property of this must be set
        //POST: obtains the user and sets the "user" property to it
        //      The user property will be nil if no user is found        
        self.completed = false;
        requester = RequestMaker(method: "GET", url: "user");
        if(self.token != nil){
            requester.authorize(self.token!);
            requester.run();
        }
        while(requester.ready == false){
            sleep(1);
        }
        if(requester.error == nil){
            self.user = requester.decodedJSON;
            self.valid = true;
        }
        else{
            self.user = nil;
            self.valid = false;
        }
        self.completed = true;
    }
    
    internal func refreshAndGetUser(){
        //PRE: the token property of this must be set
        //POST: Performs both a refresh and a get userself.completed = false;
        requester = RequestMaker(method: "GET", url: "refreshToken");
        if(self.token != nil){
            requester.authorize(self.token!);
            requester.run(setToken);
        }
        while(requester.ready == false){
            sleep(1);
        }
        self.getUser();
    }
}