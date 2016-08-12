//
//  ResultsViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/11/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController{
    
    var LocationId = Int()
    
    var reviews = [ReviewModel]()
    
    var api = ApiInterface()
    
    var location: GeolocationModel?
    
    var images = [PictureModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       getImages()
       
        
    }
    
    func getImages() {
        
        
        
       api.getPictures(ID: <#T##Int?#>, model: <#T##String?#>)
        
        
        
        while api.completed == false {
            
           sleep(1)
            
            
        }
        
        print("images = \(api.returns)")
        
        if let images = api.returns as? [PictureModel] {
            
            
            self.images = images
            
            
        }
        
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        getLocationInfo()
        
        getReviews()
    }
    
    func getLocationInfo(){
        
        print("location id = \(LocationId)")
        
        api.getGeolocation(LocationId)
        
        while api.completed == false{
            
            sleep(1)
            
        }
        
        if let locationReturned = api.returns as? GeolocationModel {
            
            location = locationReturned
            
            self.title = location?.name
            
        }
        
    }
    
    func getReviews() {
        
        
        
        api.getReviews(LocationId)
        
        while api.returns == nil {
            
            sleep(1)
        }
        
        if let retrieve = api.returns as? [ReviewModel]{
            
            reviews = retrieve
            
            
        }
        
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("number of cells = \(self.reviews.count + 1)")
    
        return reviews.count + 1
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            var cell : MainContentCell = tableView.dequeueReusableCellWithIdentifier("mainCell") as! MainContentCell

            cell.locationInfo.text = location?.description
            
            cell.ratingImageView.image = imageHandle().getImageForRating(rating: 2.5)
    
            return cell

            
            
            
        }else {
            
            let cell: ReviewTableViewCell = tableView.dequeueReusableCellWithIdentifier("reviewCell") as! ReviewTableViewCell
            
            let index = indexPath.row - 1
            
            cell.reviewerName.text = "Jacob Hall"
            
            
    
            print(Double(reviews[index].rating))
            
            cell.ratingImage.image = imageHandle().getImageForRating(rating: Double(reviews[index].rating))
            
            cell.reviewTextView.text = reviews[index].comment
            
            return cell
        }
        
        

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 580
            
        }else{
            
            
            return 237
            
        }
    }
    
    
}
