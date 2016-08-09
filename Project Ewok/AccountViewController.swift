//
//  AccountViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    var auth: Authenticator?;
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        print(auth!.user);
    }
}