//
//  ViewExtention.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/11/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

extension UIView {
    // Name this function in a way that makes sense to you...
    // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
    func SlideIn(duration: NSTimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromBottom
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func SlideOut(duration: NSTimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromTop
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
}

extension UIViewController {
    func showAlert(title title: String, message: String?, preferredStyle: UIAlertControllerStyle = UIAlertControllerStyle.Alert, actions: [UIAlertAction]? = nil){
        //PRE: The title and message must be provided. An optional style can be modified as well. Actions MUST be UIALertActions and must be in array form, even if there is only one.
        //POST: Displays a dismissable alert over the current view
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle);
        if(actions != nil){
            for action in actions! {
                alertController.addAction(action);
            }
        }
        let dismissButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel) {
            (actionButton: UIAlertAction) in
            
        }
        alertController.addAction(dismissButton);
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: false, completion: nil);
        }
    }
    
    func showAlert(title title: String, requester: RequestMaker){
        //PRE: a title and a request maker must be provided
        //POST: Interprets the status code and prints an error based on it
        //NOTE: DO NOT USE THIS FOR THE AUTHENTICATION - THIS ONLY APPLIES TO RESOURCES
        if(requester.error != nil && requester.status != nil){
            var message: String;
            switch(requester.status!){
            case 401:
                message = "You need to log in";
            case 403:
                message = "You are not permitted to do that"
            case 400:
                message = "The request is incomplete or you are too far away";
            case 410:
                message = "What you are modifying doesn't exist";
            case 409:
                message = "What you are creating already exists";
            default:
                message = "An unknown error has occured";
            }
            showAlert(title: title, message: message);
        }
    }
}