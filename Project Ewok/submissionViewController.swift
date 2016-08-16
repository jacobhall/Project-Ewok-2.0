//
//  submissionViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/10/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

import CoreLocation

class submissionViewController: UIViewController{
    
    let auth = Authenticator.sharedInstance;
    
    let interface = ApiInterface();
    
    var userCoordinates = CLLocationCoordinate2D()
    
    var locationCoordinates = CLLocationCoordinate2D()
    
    var isBeingUpdated = false
    
    var geolocationId = Int()
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var descriptionTextView: UITextView!
    
    @IBAction func SubmitButton(sender: AnyObject) {
        
        let name = self.nameTextField.text
        
        let description = self.descriptionTextView.text
        
        interface.onComplete = reportErrors;
        
        interface.createNewGeolocation(latitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude, submitterLatitude: userCoordinates.latitude, submitterLongitude: userCoordinates.longitude, name: name!, description:  description!);
        
    }
    
    func reportErrors(){
        if(interface.requester.error == nil){
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.performSegueWithIdentifier("exitToHomeSegue", sender: self);
            });
        }
        else{
            showAlert(title: "Could not create review", requester: interface.requester);
        }
    }
}
