//
//  ViewController.swift
//  Magic 8 Ball
//

import UIKit

class ViewController: UIViewController
{
    let ballArray = [#imageLiteral(resourceName: "ball1.png"),#imageLiteral(resourceName: "ball2.png"),#imageLiteral(resourceName: "ball3.png"),#imageLiteral(resourceName: "ball4.png"),#imageLiteral(resourceName: "ball5.png")]
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageView.image = ballArray[Int.random(in: 0...4)]
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
    {
        imageView.image = ballArray[Int.random(in: 0...4)]
    }
    
    @IBAction func askButtonPressed(_ sender: UIButton)
    {
        imageView.image = ballArray[Int.random(in: 0...4)]
    }
}

