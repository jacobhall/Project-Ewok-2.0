//
//  LocationsModel.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/8/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class LocationsModel {
    
    static let location = LocationsModel()
    
    var latPoint = [Double]()
    
    var longPoint = [Double]()
    
    var locationId = [Int]()
    
    var locationType = [String]()
    
    var numberOfPoints : Int {
        
        return locationId.count
        
    }
    
}
