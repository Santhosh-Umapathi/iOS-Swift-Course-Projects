//
//  ViewController.swift
//  Dicee-iOS13
//

import UIKit

class ViewController: UIViewController
{
    
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    
    func randomDiceImages()
    {
        let diceArray = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
            
        diceImageView1.image = diceArray[Int.random(in: 0...5)]
        diceImageView2.image = diceArray[Int.random(in: 0...5)]
            
        // Randomization alternative
        //  ------------------------
        //   diceImageView1.image = diceArray.randomElement()
        //   diceImageView2.image = diceArray.randomElement()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        randomDiceImages()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
    {
        randomDiceImages()
    }
        
    @IBAction func rollButtonPressed(_ sender: UIButton)
    {
        randomDiceImages()
    }
}

