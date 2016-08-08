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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        
        print("Errors: " + error.localizedDescription)
        
    }

   

    @IBAction func addButton(sender: AnyObject) {
        
        var data = retriveData(type: .Locations)
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            data.getData()
            dispatch_async(dispatch_get_main_queue()) {
                self.setPoints()
            }
        }
        
        
        
    }
    
    @IBAction func accountButton(sender: AnyObject) {
        
        print(self.mapView.region)
        
    }
    
    func setPoints() {
        
        let location = LocationsModel.location
        
        print(location.numberOfPoints)
        
        for var i = 0; i < location.numberOfPoints; i++ {
            
            print("hello")
            
        }
        
    }
    
}

