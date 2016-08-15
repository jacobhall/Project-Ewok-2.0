//
//  ViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/5/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var auth: Authenticator!;
    
    var selectedLocationId = Int()
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var listButton: UIButton!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func cancelToHome(segue:UIStoryboardSegue) {
        
    }
    
    var geoLocations = [GeolocationModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        listButton.layer.cornerRadius = 22

        self.tableView.hidden = true
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true

        
        getGeoLocations()
    
    }
    
    func getGeoLocations() {
        
        let getLocation = ApiInterface()
        
        getLocation.getGeolocations()
        
        while getLocation.completed == false {
            
            sleep(1)
            
            print(getLocation.returns)
            
        }
        
        if let results = getLocation.returns as? [GeolocationModel] {
            
            self.geoLocations = results
            
            setPoints()
            
            tableView.reloadData()
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        auth = Authenticator.sharedInstance;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
    }

    @IBAction func addButton(sender: AnyObject) {
        while(auth.completed == false){
            sleep(1);
        }
        if(auth.valid != true){
            self.performSegueWithIdentifier("loginSegue", sender: self);
        }
        else{
            self.performSegueWithIdentifier("createLocation", sender: self);
        }
        
    }
    
    
    
    @IBAction func accountButton(sender: AnyObject) {
        while(auth.completed == false){
            sleep(1);
        }
        if(auth.valid != true){
            self.performSegueWithIdentifier("loginSegue", sender: self);
        }
        else{
            self.performSegueWithIdentifier("loggedIn", sender: self);
        }
    }
    
    func setPoints() {
        
        for location in geoLocations {
            
            let dropPin = MKPointAnnotation()
            
            dropPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            dropPin.title = location.name
            
            mapView.addAnnotation(dropPin)
            
        }
        
    }
    
    
    @IBAction func ListViewButton(sender: AnyObject) {
        
        print(LocationsModel.location.latPoint)
        
        if tableView.hidden == true {
            
            tableView.hidden = false
            
            var table = self.tableView as! UIView
            
            table.SlideOut()
            
        }else {
            
            tableView.hidden = true
            
            var table = self.tableView as! UIView
            
            table.SlideIn()
            
            
        }
        
        self.view.bringSubviewToFront(sender as! UIView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return geoLocations.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let api = ApiInterface();
        
        api.getPicture(itemID: geoLocations[indexPath.row].geolocationID, model: "geolocation");
        
        let cell: TableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! TableViewCell
        
        cell.titleLabel.text = geoLocations[indexPath.row].name
        
        cell.decriptionLabel.text = geoLocations[indexPath.row].description
        
        cell.ratingImage.image = imageHandle().getImageForRating(rating: 2.5)
        
        while(api.completed == false){
            
        }
        
        cell.coverImage.image = UIImage(data: api.requester.rawData);
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedLocationId = geoLocations[indexPath.row].geolocationID
        
        
        performSegueWithIdentifier("locationSelected", sender: self)
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "locationSelected" {
            
            var destVC = segue.destinationViewController as! ResultsViewController
            
            destVC.LocationId = self.selectedLocationId
            
            
        }
    }

    
    
    
    
}
 