//
//  LoginViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    // text feilds
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // login button
    @IBAction func loginButton(sender: AnyObject) {
        login();
    }
    
    // login in
    func login() {
        let auth = Authenticator();
        if(auth.token == nil){
            if(emailField.text != nil && passwordField.text != nil){
                auth.authenticateAndRefresh(emailField.text!, passwordField.text!);
            }
            while(auth.completed == false){
                sleep(1);
            }
            if(auth.token != nil){
                print(auth.token!);
            }
        }
        else{
            auth.getUser();
            while(auth.completed == false){
                sleep(1);
            }
            print(auth.user)
            print(auth.requester.error);
        }
    }
}
