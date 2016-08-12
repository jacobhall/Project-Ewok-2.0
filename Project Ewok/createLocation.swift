//
//  createLocation.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class createLocation: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var auth: Authenticator!;
    
    @IBOutlet var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    var currentAnnotation = MKPointAnnotation()
    
    var leftBarButton = UIBarButtonItem()
    
    var userLocationWhenPinWasDropped = CLLocationCoordinate2D()
    
    var pinLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       leftBarButton = UIBarButtonItem(title: "Next", style:         UIBarButtonItemStyle.Plain, target: self, action: "barButton:")
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        
    
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        auth = Authenticator.sharedInstance;
    }
    
    func barButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("nextSegue", sender: self)
        
        
    }
    
    @IBAction func tapGesture(sender: UIGestureRecognizer) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        print(mapView.annotations.count)
       
        
        var touchPoint = sender.locationInView(self.mapView)
        
        var newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = newCoordinate
        
        pinLocation = newCoordinate
        
        mapView.addAnnotation(annotation)
        
        self.navigationItem.rightBarButtonItem = leftBarButton
        
        userLocationWhenPinWasDropped = mapView.userLocation.coordinate
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextSegue" {
            
            var dvc = segue.destinationViewController as! submissionViewController
            
            dvc.locationCoordinates = pinLocation
            
            dvc.userCoordinates = userLocationWhenPinWasDropped
            
        }
    }
    
    

}
