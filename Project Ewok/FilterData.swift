//
//  FilterData.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/17/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

class FilterData {
    
    static let sharedFilterData = FilterData()
    
    var rating : Int?
    
    var distance : Int?
    
    var operatingTime : String?
    
    var wasFiltered = Bool()

    
}