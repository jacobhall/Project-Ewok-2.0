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
    
    var index = Int()
    
    
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
    
    @IBAction func logout(sender: UIBarButtonItem) {
        auth!.destroyToken();
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        
        performSegueWithIdentifier("accountInfo", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "accountInfo" {
            
            let dest = segue.destinationViewController as! UserInfoViewController
            
            dest.index = index
            
        }
    }
}