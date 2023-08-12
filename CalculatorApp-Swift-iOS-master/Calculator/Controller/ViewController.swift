//
//  ViewController.swift
//  Calculator
//

import UIKit

class ViewController: UIViewController
{
    
    private var isFinishedTyping: Bool = true
    
    private var displayValue: Double
    {
        get
        {
            guard let number = Double(displayLabel.text!) else {fatalError("Cant convert string to double")}//Storing the first typed string as Double
            return number
        }
        set
        {
            displayLabel.text = String(newValue)
        }
    }
    
    @IBOutlet weak var displayLabel: UILabel!
    
    private var calculator = CalculatorLogic()

    @IBAction func calcButtonPressed(_ sender: UIButton)
    {
        
        isFinishedTyping = true
        
        calculator.setNumber(displayValue)
        
        if let calcMethod = sender.currentTitle
        {
            if let result = calculator.calculate(symbol: calcMethod)
            {
            displayValue = result
            }
        }
    }

    
    @IBAction func numButtonPressed(_ sender: UIButton)
    {
        if let numValue = sender.currentTitle
        {
            if isFinishedTyping == true
            {
                displayLabel.text = numValue
                isFinishedTyping = false
            }
            else
            {
                if numValue == "."
                {
                    let isInt = floor(displayValue) == displayValue
                    
                    if !isInt
                    {
                        return
                    }
                }
                displayLabel.text = displayLabel.text! + numValue
            }
        }
    }
}

