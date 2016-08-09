//
//  getData.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/5/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class retriveData {
    
    enum retrivalType: String {
        case Locations = "geolocations?GeoJSON=0"
        case UserData = ".jpg"
        case LocationData = ".json"
    }
    
    private var type = String()
    
    private var radius : Double?
    
    private var geoPoint : Double?
    
    private var name : String?
    
    private var JSONData = NSData()
    
    let baseUrl = "http://chitna.asap.um.maine.edu/projectcrowdsource/public/api/"
    
    
    init(type: retrivalType, radius: Double? = nil, geoPoint : Double? = nil, name: String? = nil){
        
        self.type = type.rawValue
        
        self.radius = radius
        
        self.geoPoint = geoPoint
        
        self.name = name
    
        
    }
    
    func getData() {
        
            let url = getUrl()
        
            print(url)

            
            let requestURL: NSURL = NSURL(string: url)!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                    
                self.JSONData = data!
                
                self.getGeolocation()
            
        }
        
            task.resume()
            
    }
    
    func getUrl() -> String{
        
        var filterUrl = baseUrl
        
        filterUrl += self.type
        
        if radius != nil {
            
            filterUrl += "&radius=\(10)"
            
        }
        
        if geoPoint != nil {
            
            filterUrl += "&latitude=\(geoPoint!)"
            
            filterUrl += "&longitude=\(1)"
        }
        
        if name != nil {
            
            filterUrl += "&name=\(name!)"
            
        }
        
        
        return filterUrl
    }
    
    private func getGeolocation(){
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: .AllowFragments)
            
            let location = LocationsModel.location
            
            
            if let events = json as? [[String: AnyObject]] {
                
                for event in events {
                    
                    if let lat = event["latitude"] as? String {
                        
                       location.latPoint.append(Double(lat)!)
                    }
                    
                    if let long = event["longitude"] as? String {
                        
                        location.latPoint.append(Double(long)!)
                        
                    }
                    
                    
                    if let geoId = event["geolocationID"] as? Int {
                        
                        location.locationId.append(geoId)
                        
                    }
                    
                    
                    if let locType = event["location_type"] as? String {
                        
                        location.locationType.append(locType)
                        
                        
                        
                    }
                    
                }
                
            }
            
            print("num of loc = \(location.numberOfPoints)")
            
            
        } catch {
            
            
            print("bad")
            
            
        }
    }
    
    private func getLocationData(){
        
       
        
    }
    
    private func getUserData(){
        
        
        
    }

    
}


