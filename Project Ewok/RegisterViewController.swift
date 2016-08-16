//
//  RegisterViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class RegisterViewController: UITableViewController {

    let auth = Authenticator.sharedInstance;
    
    //Text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    
    //On start
    override func viewDidLoad(){
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    //When the user clicks the register button
    @IBAction func register(sender: UIBarButtonItem) {
        auth.onComplete = reportErrors;
        auth.registerAndAuthenticate(emailField.text!, password: passwordField.text!, confirmed: passwordConfirmationField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!);
    }
    
    func reportErrors(){
        print(auth.valid);
        if(auth.valid == true){
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.performSegueWithIdentifier("registerSucessful", sender: self);
            });
        }
        else{
            showAlert(title: "Could not register", message: auth.requester!.error);
        }
    }
}
