//
//  UserInfoViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/17/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var index = Int()
    
    var reviews = [ReviewModel]()
    
    var locations = [GeolocationModel]()
    
    let interface = ApiInterface();

    
    override func viewDidAppear(animated: Bool) {
        
        if index == 0{
            
            getReviews()
            
        }else{
            
            getLocations()
            
        }
        
        
        
        
    }
    
    func getLocations() {
        
        if Authenticator.sharedInstance.user?.geolocations != nil {
            
            self.locations = (Authenticator.sharedInstance.user?.geolocations)!
            
        }
        
        print(locations)
        
        
    }
    
    func getReviews(){
        
        interface.onComplete = setReviews;
        
        interface.getReviews(userID: Authenticator.sharedInstance.user?.userID);
        
    }
    
    func setReviews(){
        
        if interface.returns != nil {
        
            reviews = interface.returns as! [ReviewModel];
            print("reviews = \(reviews)")
        
            self.tableView.reloadData()
            
        }

    }
    
    @IBOutlet var tableView: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if index == 0 {
        
        let cell: ReviewTableViewCell = tableView.dequeueReusableCellWithIdentifier("reviewCell") as! ReviewTableViewCell
        
        let index = indexPath.row - 1
        
        cell.ratingImage.image = imageHandle().getImageForRating(rating: Double(self.reviews[indexPath.row].rating))
        
        cell.deleteButton.addTarget(self, action: "deleteButton:", forControlEvents: .TouchUpInside)
        
        cell.deleteButton.tag = indexPath.row
        
        cell.reviewTextView.text = self.reviews[indexPath.row].comment
        
        return cell
            
        }else {
            
            return UITableViewCell()
            
            
        }
        
        
    }
    
    func deleteButton(sender: UIButton){
        
        print("pressed")
        
        var interface = ApiInterface()
        
        interface.destroyReview(reviews[sender.tag])
        
        self.reviews.removeAtIndex(sender.tag)
        
        tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if index == 0{
            
            return reviews.count
            
        }else {
            
            return locations.count
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.index == 0 {
            
            return 237
            
        }else {
            
            return 148
            
        }
    }

}