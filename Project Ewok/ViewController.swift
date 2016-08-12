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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        listButton.layer.cornerRadius = 22
        
        var getLocation = ApiInterface()
        
        getLocation.getGeolocations(100000, latitude: 1.0, longitude: 1.0)

        self.tableView.hidden = true
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
    
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
    
    func LoadPoints() {
        
        
        let data = retriveData(type: .Locations)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            data.getData()
            
            while data.isReady == false {}
            
            self.setPoints()
            
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
        
        let location = LocationsModel.location
        
        print(location.numberOfPoints)
        
        var i = 0
        
        for (i = 0; i < location.numberOfPoints; i++ ){
            
            var location = CLLocationCoordinate2D(latitude: location.latPoint[i], longitude: location.latPoint[i])
            
            var annotation = mapAnnotation()
            
            annotation.name = ""
            
            annotation.coordinate = location
            
            self.mapView.addAnnotation(annotation)
            
        }
        
    }
    
    func removeIcons() {
            
        self.mapView.removeAnnotations(self.mapView.annotations)
        
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        
        let capital = view.annotation as! mapAnnotation
        
        capital.name = ""
        
        capital.coordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        
        
        
        let ac = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
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
        
        return 5
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: TableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! TableViewCell
        
        cell.titleLabel.text = "title"
        
        cell.decriptionLabel.text = "description"
        
        cell.ratingImage.image = UIImage(named: "hello")
        
        cell.coverImage.image = UIImage(named: "hello")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedLocationId = 1 //LocationsModel.location.locationId[indexPath.row]
        
        
        performSegueWithIdentifier("locationSelected", sender: self)
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "locationSelected" {
            
            //var destVC = segue.destinationViewController as! ResultsViewController
            
            //destVC.LocationId = self.selectedLocationId
            
            
        }
    }

    
    
}
 