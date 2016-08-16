//
//  LoginViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let auth = Authenticator.sharedInstance;
    
    // text feilds
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad(){
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    // login button
    @IBAction func loginButton(sender: AnyObject) {
        login();
    }
    
    // login in
    func login() {
        auth.onComplete = reportErrors;
        auth.authenticate(emailField.text!, passwordField.text!);
    }
    
    func reportErrors(){
        if(auth.valid == true){
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.performSegueWithIdentifier("loginSuccessful", sender: self);
            });
        }
        else{
            showAlert(title: "Could not log in", message: auth.requester!.error);
        }
    }
}
