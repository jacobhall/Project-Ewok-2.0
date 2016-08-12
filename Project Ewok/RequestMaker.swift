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
     
     To authorize a request, use the "authorize" function with a 
     token as an argument
    */
    //Aliases
    typealias Payload = [String: AnyObject] //Just a dictionary
    
    //Properties
    var requestURL: NSURL;              //The request's url
    var request: NSMutableURLRequest;   //The request itslef
    var rawData = NSData();            //The data returned from the request
    var decodedJSON: Payload?;          //Holds the decoded data
    var ready: Bool?;                   //Whether or not the data is ready to use
    var status: Int?;                   //Holds the status code of the response
    var error: String?;                 //Holds an error
    
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
        if(method == "GET"){
            let getURL = url + "?" + data;
            self.init(method: method, url: getURL);
        }
        else{
            self.init(method: method, url: url, data: data.dataUsingEncoding(NSUTF8StringEncoding));
        }
    }
    
    convenience init(url: String, data: String){
        self.init(method: "GET", url: url + "?" + data);
    }
    
    convenience init(method: String, url: String){
        self.init(method: method, url: url, data: nil);
    }
    
    convenience init(url: String){
        self.init(method: "GET", url: url, data: nil);
    }
    
    //Mutators
    internal func authorize(token: String){
        self.request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization");
    }
    
    //Function
    internal func run(completion: ((NSData) -> Void)){
        //PRE: completion MUST take a single NSData argument and return void
        //POST: runs the request and updates JSONData. Sets ready to true when completed. Runs the
        //      completion argument once the request completes
        ready = false;
        error = nil;
        let task = Session.dataTaskWithRequest(request, completionHandler:  {
            (data, response, error)->Void in
            
            if(data != nil){
                self.rawData = data!;
                self.decodeData();
            }
            completion(self.rawData);
            if let httpResponse = response as? NSHTTPURLResponse {
                self.status = httpResponse.statusCode;
            }
            self.ready = true;
        });
        task.resume();
    }
    
    internal func run(completion: ((Payload) -> Void)){
        //PRE: completion MUST take a single [String: AnyObject] argument and return void
        //      Note that a [String: AnyObject] is just a simple dictionary, despite it's fancy look
        //POST: runs the request and updates JSONData. Sets ready to true when completed. Runs the
        //      completion argument once the request completes
        ready = false;
        error = nil;
        let task = Session.dataTaskWithRequest(request, completionHandler:  {
            (data, response, error)->Void in
            
            if(data != nil){
                self.rawData = data!;
                self.decodeData();
                if(self.decodedJSON != nil){
                    completion(self.decodedJSON!);
                }
            }
            if let httpResponse = response as? NSHTTPURLResponse {
                self.status = httpResponse.statusCode;
            }
            self.ready = true;
        });
        task.resume();
    }
    
    internal func run(completion: (() -> Void)){
        //POST: runs the request and updates JSONData. Sets ready to true when completed.
        //      Runs the completion when completed.
        ready = false;
        error = nil;
        let task = Session.dataTaskWithRequest(request, completionHandler:  {
            (data, response, error)->Void in
            
            self.rawData = data!;
            
            if let httpResponse = response as? NSHTTPURLResponse {
                self.status = httpResponse.statusCode;
            }
            self.decodeData();
            completion();
            self.ready = true;
        });
        task.resume();
    }
    
    internal func run(){
        //POST: runs the request and updates JSONData. Sets ready to true when completed.
        //      Use this when you do not need to handle the completion.
        ready = false;
        error = nil;
        let task = Session.dataTaskWithRequest(request, completionHandler:  {
            (data, response, error)->Void in
            
            self.rawData = data!;
            self.ready = true;
            if let httpResponse = response as? NSHTTPURLResponse {
                self.status = httpResponse.statusCode;
            }
            self.decodeData();
        });
        task.resume();
    }
    
    internal func decodeData()->Payload? {
        //POST: decodes the JSON and returns it as a dictionary, also setting the error to prevent inefficiency
        //NOTE: For some reason, error takes a second to set, so don't bank of it being nil or not nil when checking it
        //      directly after the call or in a completion handler.
        do{
            let JSON = try NSJSONSerialization.JSONObjectWithData(self.rawData, options: .AllowFragments) as? Payload;
            if JSON != nil {
                if let error = JSON!["error"] as? String {
                    self.error = error;
                }
                else if let error = JSON!["message"] as? String {
                    self.error = error;
                }
            }
            self.decodedJSON = JSON;
            return JSON;
        }
        catch{
            return nil;
        }
    }
}