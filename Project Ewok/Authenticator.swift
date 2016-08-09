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
     NEEDS TESTING!!!
     
     Basic usage:
     create an authenticator with an init() call
     
     check if the token is set from the user defaults. If not,
     act accordingly (ask the user to log in, maybe)
     
     When logging in, use an authenticate method and
     check the requester for when it finishes. The 
     requester contains an "error" property that will be set
     if there are any errors and a "ready" property that is
     set to true when the task finishes.
     
     Note that a token expires after 60 minutes but may be refreshed
     within a 2 week window. If the token has merely expired, you
     may wish to use the refresh token or the authenticateAndRefresh method
     
     When registering, use the register method or
     the registerAndAuthenticate method (per your desire).
     Handle it otherwise like an authentication.
     
     You may refresh the token periodically to prevent the user
     from being logged out too soon.
     
     When the user logs out, destroy the token.
    */
    
    //Properties
    var token: String?;             //The token
    var requester: RequestMaker!;   //The request
    
    //Constructors
    init(_ token: String?){
        //POST: sets the token (probably shouldn't use)
        if(token != nil){
            self.token = token!;
        }
        else{
            self.token = nil;
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
        }
    }
    
    //Functions
    internal func authenticate(email: String, _ password: String) {
        //PRE: email and password must be a matching pair in the DB
        //POST: runs an authenticate request and sets the token asychronously
        requester = RequestMaker(method: "POST", url: "authenticate", data: "email="+email+"&password="+password);
        requester.run(setToken);
    }
    
    internal func register(email: String, _ password: String, _ confirmed: String){
        //PRE: email must be _@_._ and password must match confirmed
        //POST: runs the register request and places the user in the DB asynchronously
        requester = RequestMaker(method: "POST", url: "register", data: "email="+email+"&password="+password+"&password_confirmation="+confirmed);
        requester.run();
    }
    
    internal func registerAndAuthenticate(email: String, password: String, confirmed: String){
        //PRE: email must be _@_._ and password must match confirmed
        //POST: runs the register request and subsequently authenticates asychronously
        requester = RequestMaker(method: "POST", url: "register", data: "email="+email+"&password="+password+"&password_confirmation="+confirmed);
        func auth() -> Void {
            authenticate(email, password);
        }
        requester.run(auth);
    }
    
    internal func refreshToken(){
        //PRE: the token property must be set and valid
        //POST: destroys the old token and sets the new token to the token property asynchronously
        requester = RequestMaker(method: "POST", url: "refreshToken");
        if(self.token != nil){
            requester.authorize(self.token!);
            requester.run(setToken);
        }
    }
    
    internal func authenticateAndRefresh(email: String, _ password: String){
        //PRE: email and password must be a matching pair in the DB
        //POST: authenticates the user and refreshes the token for added measure
        requester = RequestMaker(method: "POST", url: "authenticate", data: "email="+email+"&password="+password);
        requester.run(refreshToken);
    }
    
    internal func destroyToken(){
        //PRE: the token property must be set and valid
        //POST: destroys the token so it can no longer be used
        requester = RequestMaker(method: "POST", url: "destroyToken");
        if(self.token != nil){
            requester.authorize(self.token!);
            requester.run();
        }
    }
}