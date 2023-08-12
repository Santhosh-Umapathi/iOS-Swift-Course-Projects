//  TabBarVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 11/22/19.
//  Copyright © 2019 App City. All rights reserved.


import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate
{
    
    
   override func viewWillAppear(_ animated: Bool)
    { super.viewWillAppear(animated) }
       
       
    override func viewDidAppear(_ animated: Bool)
    { super.viewDidAppear(animated) }
    
  
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tabBarTextColorSettings()
        tabBarIconSettings()
        self.delegate = self

    }
    
    //Setting Workouuts VC to Root page every time tab changed
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        if let vc = viewController as? UINavigationController
        { vc.popToRootViewController(animated: false) }
    }
    
    
    //MARK: - Tab Bar Color Settings
    func tabBarTextColorSettings()
    {
        // Tab Bar Text colors
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        
        // Tab Bar Colors HexCode - "121212"
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
        UITabBar.appearance().isTranslucent = false
    }
    
    //MARK: - Tab Bar Icon Settings
    var tabBarItems = UITabBarItem()
    
    func tabBarIconSettings()
    {
        // Tab Icon Color Hex Codes
            // Dark Mode = Gray - "7d7d7d"
            // Light Mode = White - "ffffff"
        
        //Tab 1
        let selectedImageIcon1 = UIImage(named: "Start Workout Light")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageIcon1 = UIImage(named: "Start Workout Dark")?.withRenderingMode(.alwaysOriginal)
        
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deselectedImageIcon1
        tabBarItems.selectedImage = selectedImageIcon1
        
        //Tab 2
        let selectedImageIcon2 = UIImage(named: "Workouts Light")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageIcon2 = UIImage(named: "Workouts Dark")?.withRenderingMode(.alwaysOriginal)
        
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deselectedImageIcon2
        tabBarItems.selectedImage = selectedImageIcon2
        
        //Tab 3
        let selectedImageIcon3 = UIImage(named: "Build Plan Light")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageIcon3 = UIImage(named: "Build Plan Dark")?.withRenderingMode(.alwaysOriginal)
        
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deselectedImageIcon3
        tabBarItems.selectedImage = selectedImageIcon3
        
        //Tab 4
        let selectedImageIcon4 = UIImage(named: "Settings Light")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageIcon4 = UIImage(named: "Settings Dark")?.withRenderingMode(.alwaysOriginal)
        
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deselectedImageIcon4
        tabBarItems.selectedImage = selectedImageIcon4
        
        self.selectedIndex = 0 //Loading Tab 1 as startup default screen
    }
}




