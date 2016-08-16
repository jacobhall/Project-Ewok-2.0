//
//  CreateReviewViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/15/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class CreateReviewViewController: UIViewController {
    
    // holds the id of the geolocation passed to it
    
    var recivedGeoID = Int()
    
    let interface = ApiInterface();
    
    @IBOutlet var reviewTextView: UITextView!
    
    @IBOutlet var ratingSegControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func submitReviewButton(sender: AnyObject) {
        
        // submit data to api then go back to previous screen
        
        
        
        let reviewText = self.reviewTextView.text
        
        let rating = self.ratingSegControl.selectedSegmentIndex
        
        
        
        // API CODE
        interface.onComplete = submitReview;
        interface.createNewReview(geolocationID: recivedGeoID, rating: rating, comment: reviewText);
    }
    
    
    //Functional Code
    func submitReview(){
        if(interface.requester.error == nil){
            performSegueWithIdentifier("back", sender: self);
        }
        else{
            showAlert(title: "Could not create review", requester: interface.requester);
        }
    }
}
