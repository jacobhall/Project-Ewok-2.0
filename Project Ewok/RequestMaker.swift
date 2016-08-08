//
//  RequestMaker.swift
//  Project Ewok
//
//  Created by asap on 8/8/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

class RequestMaker{
    /**
     Basic usage:
     use one of the constructors to make the request
     Always be sure to include a URL component
     
     Call the run function, either leaving arguments empty
     or adding a "completion" argument with a function that takes
     NSData as an argument
     
     The run function will asynchronously update the JSONData and
     set ready to true upon completion.
     
     If a function was used as an argument for run, that function
     will be called when the task is completed.
    */
    
    //Properties
    var requestURL: NSURL;              //The request's url
    var request: NSMutableURLRequest;   //The request itslef
    var JSONData: NSData?;              //The data returned from the request
    var ready: Bool?;                   //Whether or not the data is ready to use
    
    //Constants
    let Session = NSURLSession.sharedSession(); //The session
    let BaseURL = "http://chitna.asap.um.maine.edu/projectcrowdsource/public/api/"; //The base URL for the API
    
    //Constructor
    init(method: String, url: String, data: NSData?){
        requestURL = NSURL(string: BaseURL + url)!;
        request = NSMutableURLRequest(URL: requestURL);
        request.HTTPMethod = method;
        request.HTTPBody = data;
        ready = false;
    }
    
    convenience init(method: String, url: String, data: String){
        self.init(method: method, url: url, data: data.dataUsingEncoding(NSUTF8StringEncoding));
    }
    
    convenience init(url: String, data: String){
        self.init(method: "GET", url: url, data: data.dataUsingEncoding(NSUTF8StringEncoding));
    }
    
    convenience init(method: String, url: String){
        self.init(method: method, url: url, data: nil);
    }
    
    convenience init(url: String){
        self.init(method: "GET", url: url, data: nil);
    }
    
    //Function
    internal func run(completion: ((NSData) -> Void)?){
        //PRE: if completion is included, completion MUST take a single NSData argument and return void
        //POST: runs the request and updates JSONData. Sets ready to true when completed. Runs the
        //      completion argument once the request completes if completion is included.
        ready = false;
        let task = Session.dataTaskWithRequest(request, completionHandler:  {
            (data, response, error)->Void in
            
            self.JSONData = data!;
            self.ready = true;
            if(completion != nil){
                completion!(self.JSONData!);
            }
        });
        task.resume();
    }
}