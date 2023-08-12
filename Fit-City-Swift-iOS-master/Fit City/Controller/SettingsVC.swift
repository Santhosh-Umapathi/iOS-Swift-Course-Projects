//  SettingsVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 11/23/19.
//  Copyright © 2019 App City. All rights reserved.

import UIKit
import RealmSwift
import Firebase


// Setup Page with User Settings

class SettingsVC: UIViewController
{
  
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    @IBOutlet weak var signOutTapped: UIButton!
    
    var addOns = AddOns()

    
    override func viewDidLoad()
    {
        signOutButtonSettings()
        
        //routineView()
    }
    
     override func viewWillDisappear(_ animated: Bool)
       {
           super.viewWillDisappear(animated)
       }
       
       override func viewDidDisappear(_ animated: Bool)
       {
           super.viewDidDisappear(animated)
       }
    
    func signOutButtonSettings()
    {
        signOutTapped.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        
        signOutTapped.layer.borderColor = UIColor.systemBlue.cgColor
        signOutTapped.layer.cornerRadius = 5
        signOutTapped.layer.borderWidth = 1
    }
    
    
    
    @objc func handleSignOut()
    {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to Sign Out?", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in self.signOut() }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func signOut()
    {
        do
        {
            try! Auth.auth().signOut()
            transitionToWelcomeScreen()
            print("SignOut Successful - Login Status = \(UserDefaults.standard.bool(forKey: "isUserLoggedIn"))")
        }
        //catch let error { print("Failed to SignOut", error) }
    }
    
    func transitionToWelcomeScreen()
    {
        addOns.isUserLoggedIn(value: false)
        
       // view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    //works but login screen flashes
    //self.performSegue(withIdentifier: "unwindToWelcomeScreenVC", sender: self) //Exit to BuildPlanVC

        

        
        
        
//        guard let navigationController = self.navigationController else { return }
//        var navigationViewControllers = navigationController.viewControllers
//        navigationViewControllers.removeLast(navigationViewControllers.count - 1)
//        self.navigationController?.viewControllers = navigationViewControllers
//
//         self.dismiss(animated: true)
//                  {
//                    let _ = navigationController.popToRootViewController(animated: true)
//                  }

        //self.dismiss(animated: true, completion: nil)

        //navigationController?.dismiss(animated: true, completion: nil)

        
        
        let welcomeScreenVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeScreenVC") as? WelcomeScreenVC
        view.window?.rootViewController = welcomeScreenVC
        welcomeScreenVC?.logoAnimation(duration: 2, delay: 0)
        view.window?.makeKeyAndVisible()   
    }
    
    
 
//
//        func transitionToWelcomeScreen()
//        {
//            addOns.isUserLoggedIn(value: false)
//
//    //        let homeVC = storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
//    //        view.window?.rootViewController = homeVC
//    //        view.window?.makeKeyAndVisible()
//
//
//
//
//        }
    

    
//    func routineView()
//    {
//        self.view.alpha = 0.5
//        var routineView = UIView()
//        routineView.backgroundColor = .red
//        view.addSubview(routineView)
//
//        routineView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 150, left: 50, bottom: 150, right: 50), size: .init(width: 200, height: 200))
//
//
//    }
    
          
    
    
}





   
    
   
    
   

            

