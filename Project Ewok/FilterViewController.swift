//
//  FilterViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/17/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet var distanceSegController: UISegmentedControl!
    
    @IBOutlet var ratingSegController: UISegmentedControl!
    
    @IBOutlet var timeSegController: UISegmentedControl!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewWillAppear(animated: Bool) {
        setStates()
    }
    
    func setSegControllers() {
        
        
        
    }
    
    @IBAction func filterButton(sender: AnyObject) {
        
        var time : String?
        
        switch timeSegController.selectedSegmentIndex {
            
        case 0:
            time = nil
            break
        case 1:
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let minute = calendar.component(.Minute, fromDate: date)
            let hour = calendar.component(.Hour, fromDate: date)
            
            var dateSting = String()
            
            if hour < 10 {
                
                dateSting = "0\(hour):"
                
            }else {
                
                dateSting = "\(hour):"
                
            }
            
            if minute < 10 {
                
                dateSting += "0\(minute):00"
                
                
            }else {
                
                dateSting += "\(minute):00"
                
            }
            
           time = dateSting
            
            break
        case 2:
            var date = NSDate()
           
            date = datePicker.date
            
            let calendar = NSCalendar.currentCalendar()
            let minute = calendar.component(.Minute, fromDate: date)
            let hour = calendar.component(.Hour, fromDate: date)
            
            var dateSting = String()
            
            if hour < 10 {
                
                dateSting = "0\(hour):"
                
            }else {
                
                dateSting = "\(hour):"
                
            }
            
            if minute < 10 {
                
                dateSting += "0\(minute):00"
                
                
            }else {
                
                dateSting += "\(minute):00"
                
            }
            
            time = dateSting
            
            print(time)
            
            

            break
        default:
            
            break
        }
        
        FilterData.sharedFilterData.operatingTime = time
        
        var rating : Int?
        
        switch ratingSegController.selectedSegmentIndex {
            
        case 0:
            rating = nil
            break
        case 1:
            rating = 0
            break
        case 2:
            rating = 1
            break
        case 3:
            rating = 2
            break
        case 4:
            rating = 3
            break
        case 5:
            rating = 4
            break
        case 6:
            rating = 5
            break
        default:
            
            break
        }
        
        var distance : Int?
        
        switch distanceSegController.selectedSegmentIndex {
            
        case 0:
            distance = nil
            break
        case 1:
            distance = 25
            break
        case 2:
            distance = 75
            break
        case 3:
            distance = 150
            break
        default:
            
            break
        }
        
        FilterData.sharedFilterData.operatingTime = time
        
        FilterData.sharedFilterData.distance = distance
        
        FilterData.sharedFilterData.rating = rating
        
        FilterData.sharedFilterData.wasFiltered = false
        
        self.performSegueWithIdentifier("submit", sender: self)
        
    }
    
    @IBAction func timeSegControllerAction(sender: AnyObject) {
        
        if timeSegController.selectedSegmentIndex == 2 {
            
            datePicker.hidden = false
            
        }else {
            
            datePicker.hidden = true
            
        }
        
    }
    
    func setStates() {
        
        if FilterData.sharedFilterData.operatingTime == nil{
        
            timeSegController.selectedSegmentIndex = 0
        
        }else{
            
           timeSegController.selectedSegmentIndex = 2
            
        }
        
        var distanceIndex : Int
        
        switch FilterData.sharedFilterData.distance {
            
        case nil:
            
            distanceIndex = 0
            
            break
        case 25?:
            
            distanceIndex = 1
            
            break
            
        case 75?:
            
            distanceIndex = 2
            
            break
        case 150?:
            
            distanceIndex = 3
            
            break
        default:
            distanceIndex = 0
        }
        
        self.distanceSegController.selectedSegmentIndex = distanceIndex
        
        var ratingIndex : Int
        
        switch FilterData.sharedFilterData.rating {
            
        case nil:
            
            ratingIndex = 0
            
            break
        case 0?:
            
            ratingIndex = 1
            
            break
            
        case 1?:
            
            ratingIndex = 2
            
            break
        case 2?:
            
            ratingIndex = 3
            
            break
        case 3?:
            
            ratingIndex = 4
            
            break
            
        case 4?:
            
            ratingIndex = 5
            
            break
        case 5?:
            
            ratingIndex = 6
            
            break
        default:
            ratingIndex = 0
        }
        
        self.ratingSegController.selectedSegmentIndex = ratingIndex

        
        
    }
    
}
