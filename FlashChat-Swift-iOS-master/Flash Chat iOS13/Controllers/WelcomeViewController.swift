//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController
{

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    //Disabling navigation bar on welcome screen
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //Re-enabling navigation bar after welcome screen
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = Constants.titleName

        
        
//        //Creating title logo Typing animation
//        titleLabel.text = ""
//        var titleTimer = 0.0
//        let titleText = "⚡️FlashChat"
//
//        for letter in titleText
//        {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * titleTimer, repeats: false)
//            {   (timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            titleTimer += 1
//        }

       
    }
    

}
