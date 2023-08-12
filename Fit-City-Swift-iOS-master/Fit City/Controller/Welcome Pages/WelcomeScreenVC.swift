//
//  WelcomeScreenViewController.swift
//  Fit City
//
//  Created by Santhosh Umapathi on 11/19/19.
//  Copyright © 2019 App City. All rights reserved.
//

// Autolayout settings for starting pages



import UIKit
import AVFoundation
import Firebase


class WelcomeScreenVC: UIViewController
{

    @IBOutlet weak var fitLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var logoText: UILabel!
    @IBOutlet weak var googleSignUp: UIButton!
    @IBOutlet weak var facebookSignup: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    
   // @IBAction func unwindToWelcomeScreen(sender: UIStoryboardSegue){}

    
    
    var addOns = AddOns()
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        signUpButtonSettings()
        logoAnimation(duration: 2, delay: 1.8)
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false)
//        { (timer) in
//            NotificationCenter.default.post(name: splashViewNotificationName, object: nil)
//        }
       
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        //super.viewWillAppear(animated)
       // logoAnimation()        
        
        //authenticateUser()
        //super.viewWillAppear(animated)
//        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true
//               {
//                   print(UserDefaults.standard.bool(forKey: "isUserLoggedIn"))
//                   DispatchQueue.main.async
//                   {
//                   let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
//                   self.view.window?.rootViewController = homeVC
//                   self.view.window?.makeKeyAndVisible()
//                   }
//               }
        
        
    }
       
       
//    override func viewDidAppear(_ animated: Bool)
//    { super.viewDidAppear(animated) }
//
//    override func viewWillDisappear(_ animated: Bool)
//    { super.viewWillDisappear(animated) }
//
//    override func viewDidDisappear(_ animated: Bool)
//    { super.viewDidDisappear(animated) }

    
    


    
//    func authenticateUser()
//      {
//          if let user = Auth.auth().currentUser
//          {
//              DispatchQueue.main.async
//              {
//                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
//                self.view.window?.rootViewController = homeVC
//                self.view.window?.makeKeyAndVisible()
//              }
//          }
//      }
    
    func signUpButtonSettings()
    {
        signUpButton.layer.borderColor = UIColor.systemBlue.cgColor
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 1
    }
    
  
 
    //MARK: - Welcome Screen Label Animation
    func logoAnimation(duration: TimeInterval, delay: TimeInterval)
    {
        fitLabel.alpha = 0.10
        cityLabel.alpha = 0.10
        logoText.alpha = 0.10
        
        UIView.animate(withDuration: duration, delay: delay, options: .transitionCurlDown, animations:
        {
            self.fitLabel.text = "FIT"
            self.fitLabel.alpha = 1
            
            self.cityLabel.text = "CITY"
            self.cityLabel.alpha = 1
            
            self.logoText.text = "Fit Life starts here"
            self.logoText.alpha = 1
        }, completion: nil)
        
       
    }
    
    
    

    
    
}

