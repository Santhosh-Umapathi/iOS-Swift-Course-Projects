//
//  RegisterViewController.swift
//  Flash Chat iOS13
//

import UIKit
import Firebase

class RegisterViewController: UIViewController
{
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
        if let email = emailTextfield.text , let password = passwordTextfield.text
        {   //Code from Firebase
            Auth.auth().createUser(withEmail: email, password: password)
            { authResult, error in
              if let e = error
                {
                    print(e)
                }
                else
                {
                    //Navigate to Chat View Controller if Successful
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
    }
}
