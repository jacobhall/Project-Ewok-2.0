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
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var nextButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    
    var currentAnnotation = MKPointAnnotation()
    
    var leftBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       leftBarButton = UIBarButtonItem(title: "Next", style:         UIBarButtonItemStyle.Plain, target: self, action: "barButton:")
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        
    
        
        
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
        
        annotation.title = "New Place"
        
        annotation.subtitle = "One day I'll go here..."
        
        mapView.addAnnotation(annotation)
        
        self.navigationItem.rightBarButtonItem = leftBarButton
        
        
        
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
    
    

}
