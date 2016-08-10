//
//  RegisterViewController.swift
//  Project Ewok
//
//  Created by Jacob Hall on 8/9/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import UIKit

class RegisterViewController: UITableViewController {

    var auth: Authenticator?;
    
    //Text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    
    //On start
    override func viewDidLoad(){
        if(auth == nil){
            auth = Authenticator();
        }
    }
    
    //When the user clicks the register button
    @IBAction func register(sender: UIButton) {
        auth!.registerAndAuthenticate(emailField.text!, password: passwordField.text!, confirmed: passwordConfirmationField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!)
        while(auth!.completed == false){
            sleep(1);
        }
        if(auth!.valid == true){
            self.performSegueWithIdentifier("registerSucessful", sender: self);
        }
        else{
            //TO DO: ERROR PROMPTS
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "backToLoginSegue"){
            let navVC = segue.destinationViewController as! UINavigationController;
            let destinationVC = navVC.viewControllers.first as! LoginViewController;
            destinationVC.auth = self.auth;
        }
    }
}
