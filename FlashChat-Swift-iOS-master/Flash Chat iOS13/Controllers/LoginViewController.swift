//
//  LoginViewController.swift
//  Flash Chat iOS13
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    @IBAction func loginPressed(_ sender: UIButton)
    {
        if let email = emailTextfield.text , let password = passwordTextfield.text
        {   //Code from Firebase
            Auth.auth().signIn(withEmail: email, password: password)
            {  authResult, error in
                if let e = error
                {
                    print("Login not successfull \(e)")
                }
                else
                {
                //Navigate to Chat View Controller if Successful
                self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
            }
        }
    }
}

