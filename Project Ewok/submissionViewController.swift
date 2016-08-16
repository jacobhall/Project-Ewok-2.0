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
    
    var auth: Authenticator!;
    
    var userCoordinates = CLLocationCoordinate2D()
    
    var locationCoordinates = CLLocationCoordinate2D()
    
    var isBeingUpdated = false
    
    var geolocationId = Int()
    
    override func viewWillAppear(animated: Bool) {
        auth = Authenticator.sharedInstance;
    }
    
    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var descriptionTextView: UITextView!
    
    @IBAction func SubmitButton(sender: AnyObject) {
        
        let name = self.nameTextField.text
        
        let description = self.descriptionTextView.text
        
        let maker = RequestMaker(method: "POST", url: "geolocations", data: "latitude=\(locationCoordinates.latitude)&longitude=\(locationCoordinates.longitude)&submitterLongitude=\(userCoordinates.longitude)&submitterLatitude=\(userCoordinates.latitude)&name=\(name!)&description=\(description)")
        
        maker.authorize(auth.token!)
        
        maker.run()
        
        while maker.ready! == false {
            
            sleep(1)
            
        }
        
        self.performSegueWithIdentifier("exitToHomeSegue", sender: self)
    }
}
