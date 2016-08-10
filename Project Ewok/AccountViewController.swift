//
//  AccountViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    var auth: Authenticator?;
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        print(auth!.user);
        
        if(auth == nil){
            auth = Authenticator();
        }
    }
    
    @IBAction func logout(sender: UIButton) {
        auth!.destroyToken();
        while(auth!.completed == false){
            sleep(1);
        }
    }
}