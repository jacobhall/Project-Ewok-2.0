//
//  LoginViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var auth: Authenticator?;
    
    // text feilds
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad(){
        
    }
    
    override func viewWillAppear(animated: Bool) {
        auth = Authenticator.sharedInstance;
    }
    
    // login button
    @IBAction func loginButton(sender: AnyObject) {
        login();
    }
    
    // login in
    func login() {
        auth!.authenticate(emailField.text!, passwordField.text!)
        while(auth!.completed == false){
            sleep(1);
        }
        if(auth!.valid == true){
            self.performSegueWithIdentifier("loginSuccessful", sender: self);
        }
        else{
            //TO DO: ADD ERROR PROMPTS
        }
    }
}
