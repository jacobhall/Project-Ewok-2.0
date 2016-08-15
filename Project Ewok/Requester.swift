//
//  RequesterProtocol.swift
//  Project Ewok
//
//  Created by asap on 8/15/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class Requester {
    /**
     This class is used by anything that directly makes requests.
     It has a requester and a completed boolean to make requests and tell when they are completed.
     It also has an optional onComplete function that is called when setComplete is done.
     setComplete should be called at the end of any request.
     */
    var requester: RequestMaker!;
    var completed: Bool!;
    var onComplete: (()->Void)?;
    internal func setCompleted() {
        if(onComplete != nil){
            onComplete!();
        }
        completed = true;
    }
    
    init(){
        
    }
}