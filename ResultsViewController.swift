//
//  ResultsViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/11/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let auth = Authenticator.sharedInstance;
    
    var LocationId = Int()
    
    var reviews = [ReviewModel]()
    
    var api = ApiInterface()
    
    var location: GeolocationModel?
    
    var images = [PictureModel]()
    
    var PageController = UIPageControl()
    
    var scrollView = UIScrollView()
    
    @IBAction func undwindToResults(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        
        scrollView.delegate = self
        
        super.viewDidLoad()
        
    }
    
    func getImages() {

        api.getPictures(location!.geolocationID, model: "geolocation");
        
        while api.completed == false {
            
        }
        
        print("images = \(api.returns)")
        
        if let images = api.returns as? [PictureModel] {
            
            
            self.images = images
            
        }
        
        
    }
    
    func addImages(){
        
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        getLocationInfo()
        
        getReviews()
        
        getImages()
        
        PageController.currentPage = 3
        
        
    }
    
    func getLocationInfo(){
        
        print("location id = \(LocationId)")
        
        api.getGeolocation(LocationId)
        
        while api.completed == false{
            
            print(api.completed)
            
        }
        
        print("done get geo")
        
        
        if let locationReturned = api.returns as? GeolocationModel {
            
            print("if let passed")
            
            location = locationReturned
            
            print(locationReturned)
            
            self.title = location?.name
            
        }
        
    }
    
    func getReviews() {
        
        print("getting reviews")
        
        print(LocationId)
        
        api.getReviews(LocationId)
        
        while api.completed == false {
            
            print("in loop")
            
        }
        
        print("got done wait")
        
        if let retrieve = api.returns as? [ReviewModel]{
            
            
            print("if let passed")
            
            print(retrieve)
            
            reviews = retrieve
            
            
        }
        
        print("done")
        
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("number of cells = \(self.reviews.count + 1)")
    
        return reviews.count + 1
        
    }
    
    // Adds a alert for camera and photo library
    func addImageAction() {
        //Checks if the user is authenticated and requires them to login if not
        if(auth.valid == true){
            let actionSheetController: UIAlertController = UIAlertController(title: "Add Image to location", message: nil, preferredStyle: .ActionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                
                
                
            }
            actionSheetController.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Image", style: .Default)
            { action -> Void in
                // Code for taking an image
                
                //Checking the camera exists
                if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                    //If it does, we allow them to take a picture
                    let picker = UIImagePickerController();
                    picker.delegate = self;
                    picker.allowsEditing = false;
                    picker.sourceType = UIImagePickerControllerSourceType.Camera;
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(picker, animated: true, completion: nil);
                    });
                }
                else{
                    //If not, we display an error
                    self.showAlert(title: "No camera available", message: nil);
                }
            }
            actionSheetController.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default)
            { action -> Void in
                // code for getting image from library
                let picker = UIImagePickerController();
                picker.delegate = self;
                picker.allowsEditing = false;
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(picker, animated: true, completion: nil);
                });
            }
            actionSheetController.addAction(deleteActionButton)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
        else{
            showAlert(title: "Not logged in", message: "Please log in to continue", actions: [loginButton()]);
        }
    }
    
    //Called when a picture is taken and/or selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage!; //The UIImage taken
        api.onComplete = errorPrompt;
        api.createNewPicture(image: image, attachedModel: "geolocation", attachedID: LocationId);
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func errorPrompt(){
        if(api.requester.error != nil){
            showAlert(title: "Could not create picture", requester: api.requester);
        }
        else{
            showAlert(title: "Image created", message: nil);
        }
    }
    
    //Called when the user cancels image picking
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // preform segue to reviewViewController
    
    //Create a log in action for the alert
    func loginButton() -> UIAlertAction {
        return UIAlertAction(title: "Log in", style: UIAlertActionStyle.Default, handler: {
            (alert) in
            let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController;
            self.navigationController!.pushViewController(destinationVC, animated: true);
        });
    }
    
    func createReviewAction() {
        if(auth.valid == true){
            performSegueWithIdentifier("review", sender: self);
        }
        else{
            showAlert(title: "Not logged in", message: "Please log in to continue", actions: [loginButton()]);
        }
    }
    
    func UpdateInfoButton() {
        
        // TODO: Perform segue to creating a location to reuse the view contoller
        if(auth.valid == true){
            self.performSegueWithIdentifier("updateSegue", sender: self)
        }
        else{
            showAlert(title: "Not logged in", message: "Please log in to continue", actions: [loginButton()]);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "review" {
            
            var dest = segue.destinationViewController as! CreateReviewViewController
            
            // passes locationId to CreateReviewViewController
            
            dest.recivedGeoID = self.LocationId
            
            
        }else if segue.identifier == "updateSegue" {
            
            var dest = segue.destinationViewController as! submissionViewController
            
            dest.isBeingUpdated = true
            
            dest.geolocationId = self.LocationId
        
        }
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            var cell : MainContentCell = tableView.dequeueReusableCellWithIdentifier("mainCell") as! MainContentCell
            
            var xPosition:CGFloat = 0
            
            var height: CGFloat = 0
            
            scrollView = cell.imageScrollView
            
            cell.imagePageControl.numberOfPages = images.count
            
            // Buttons at the top of screen, Adding actions
            
            cell.addImageButton.addTarget(self, action: "addImageAction", forControlEvents: .TouchUpInside)
        
            cell.createReviewButton.addTarget(self, action: "createReviewAction", forControlEvents: .TouchUpInside)
            
            cell.UpdateInfoButton.addTarget(self, action: "UpdateInfoButton", forControlEvents: .TouchUpInside)
            
            self.PageController = cell.imagePageControl
            
            for image in images {
                
                let imageView = UIImageView()
                
                imageView.setImageFromPictureModel(image)
                
                imageView.frame.size.width = scrollView.frame.size.width
                
                imageView.frame.size.height = scrollView.frame.size.height
                
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
                
                imageView.frame.origin.x = xPosition
                
//                imageView.backgroundColor = UIColor.blackColor()
                
                print(xPosition)
                
                xPosition += imageView.frame.width
                
                scrollView.addSubview(imageView)
                
                print("added")
                
            }
            
            scrollView.contentSize = CGSize(width: xPosition, height: height)

            
            cell.imageScrollView = scrollView

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
