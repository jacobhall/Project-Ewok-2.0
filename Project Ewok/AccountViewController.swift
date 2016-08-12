//
//  AccountViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    var auth: Authenticator!;
    
    override func viewDidLoad(){
        super.viewDidLoad();
    }
    
    override func viewWillAppear(animated: Bool) {
        auth = Authenticator.sharedInstance;
        if(auth.user == nil){
            auth.getUser();
        }
        print(auth.user);
    }
    
    @IBAction func logout(sender: UIButton) {
        auth!.destroyToken();
        while(auth!.completed == false){
            sleep(1);
        }
    }
}