//
//  imageHandle.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/12/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation
import UIKit

class imageHandle {
    
    init() {
        
        
    }
    
    func getImageForRating(rating r: Double) -> UIImage {
        
        var imageName = String()
        
        if r >= 0 || r < 0.25 {
            
            imageName = "0"
            
        }else if r >= 0.25 || r < 0.75 {
            
            imageName = "05"
            
        }else if r >= 0.75 || r < 1.25 {
            
            imageName = "1"
            
        }else if r >= 1.25 || r < 1.75 {
            
            imageName = "15"
            
        }else if r >= 1.75 || r < 2.25 {
            
            imageName = "2"
            
        }else if r >= 2.25 || r < 2.75 {
            
            imageName = "25"
            
        }else if r >= 2.75 || r < 3.25 {
            
            imageName = "3"
            
        }else if r >= 3.25 || r < 3.75 {
            
            imageName = "35"
            
        }else if r >= 3.75 || r < 4.25 {
            
            imageName = "4"
            
        }else if r >= 4.25 || r < 3.75 {
            
            imageName = "45"
            
        }else if r >= 3.75 || r < 5{
            
            imageName = "5"
            
        }
        
        return UIImage(named: imageName)!
        
    }
    
    
    
    
}