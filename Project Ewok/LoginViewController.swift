//
//  LoginViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let auth = Authenticator();
    
    // text feilds
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // login button
    @IBAction func loginButton(sender: AnyObject) {
        login();
    }
    
    // login in
    func login() {
        auth.authenticate(emailField.text!, passwordField.text!)
    }
}
