//
//  ResultsViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/11/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController{
    
    var LocationId = Int()
    
    var results = [ReviewModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var api = ApiInterface()
        
        api.getReviews(LocationId)
        
        while api.returns == nil {
            
            sleep(1)
        }
        
        var results = api.returns
        
        var hi = results[1]
        
        hi.
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return 1
            
        }else if section == 1{
            
            return 2
            
        }else {
            
            return 0
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            
            
        }else if indexPath.section == 1{
            
            
            
        }
        
        return UITableViewCell()

    }
    
    
    
    
}
