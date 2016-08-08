//
//  RequestMaker.swift
//  Project Ewok
//
//  Created by asap on 8/8/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

class RequestMaker{
    //Properties
    var requestURL: NSURL;
    var request: NSMutableURLRequest;
    var JSONData: NSData?;
    var ready: Bool?;
    
    //Constants
    let Session = NSURLSession.sharedSession();
    let BaseURL = "http://chitna.asap.um.maine.edu/projectcrowdsource/public/api/";
    
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