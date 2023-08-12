//  AddExerciseVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 1/11/20.
//  Copyright © 2020 App City. All rights reserved.

import UIKit
import SkyFloatingLabelTextField
import RealmSwift

class AddExercisePopUp: UIViewController
{
    @IBOutlet weak var exerciseNameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var bodyPartNameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var categoryNameTextField: SkyFloatingLabelTextFieldWithIcon?
    @IBOutlet weak var cancelButtonTapped: UIButton!
    @IBOutlet weak var addButtonTapped: UIButton!
    
    @IBOutlet weak var popUpView: UIView!



    @IBOutlet weak var labelStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var addLabel: UILabel!
    
    
    let realm = try! Realm() //Realm Declaration
    let newExercise = Exercises() //Exercises Class Declaration
    var addOns = AddOns() //Implementing additional functions from struct

    override func viewDidLoad()
    {
        popUpViewSettings()
        textFieldSettings()
        addButtonSettings()
        cancelButtonSettings()
    }
    
    func popUpViewSettings()
    { popUpView.layer.cornerRadius = 10
        addLabel.layer.borderWidth = 1
        addLabel.layer.borderColor = UIColor.darkGray.cgColor
        addLabel.layer.cornerRadius = 10
    }
      

    func textFieldSettings()
    {
        //Font Awesome Cheat Sheet for font icons
        //https://fontawesome.com/cheatsheet?from=io#use
        //https://fontawesome.com/cheatsheet/pro
        //exerciseNameTextField.iconType = .font
        //exerciseNameTextField.iconFont = UIFont(name: "FontAwesome5Free-Solid", size: 15)
        //exerciseNameTextField.iconText = "\u{f44b}"

        //Exercise Name Text Field Settigns
        exerciseNameTextField.frame = CGRect(x: 89 , y: 77, width: 197, height: 45)
        exerciseNameTextField.iconType = .image
        exerciseNameTextField.iconImage = UIImage(named: "Exercise Name Icon")

        exerciseNameTextField.errorColor = .systemRed
        exerciseNameTextField.addTarget(self, action: #selector(exerciseNameTextFieldChanged(_:)), for: .editingChanged)


        //BodyPart Name Text Field Settigns
        bodyPartNameTextField.frame = CGRect(x: 89 , y: 133, width: 197, height: 45)
        bodyPartNameTextField.iconType = .image
        bodyPartNameTextField.iconImage = UIImage(named: "BodyPart Name Icon")

        bodyPartNameTextField.errorColor = .systemRed
        bodyPartNameTextField.addTarget(self, action: #selector(bodyPartNameTextFieldChanged(_:)), for: .editingChanged)


        //Category Name Text Field Settigns
        categoryNameTextField!.frame = CGRect(x: 89 , y: 190, width: 197, height: 45)
        categoryNameTextField!.iconType = .image
        categoryNameTextField!.iconImage = UIImage(named: "Category Name Icon")
     }


    @objc func exerciseNameTextFieldChanged(_ textfield: UITextField)
    {
        if let text = textfield.text
        {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField
            {
                if text.isEmpty
                {
                    floatingLabelTextField.errorMessage = "Enter Exercise Name"
                    addButtonTapped.shake()
                    addButtonTapped.layer.borderColor = UIColor.systemRed.cgColor
                    addButtonTapped.tintColor = .systemRed
                }
                else // The error message will only disappear when we reset it to nil or empty string
                {
                    floatingLabelTextField.errorMessage = ""
                    addButtonTapped.layer.borderColor = UIColor.systemBlue.cgColor
                    addButtonTapped.tintColor = .systemBlue
                }
            }}}

    @objc func bodyPartNameTextFieldChanged(_ textfield: UITextField)
    {
        if let text = textfield.text
        {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField
            {
                if text.isEmpty
                {
                    floatingLabelTextField.errorMessage = "Enter Body Part Name"
                    addButtonTapped.shake()
                    addButtonTapped.layer.borderColor = UIColor.systemRed.cgColor
                    addButtonTapped.tintColor = .systemRed
                }
                else // The error message will only disappear when we reset it to nil or empty string
                {
                    floatingLabelTextField.errorMessage = ""
                    addButtonTapped.layer.borderColor = UIColor.systemBlue.cgColor
                    addButtonTapped.tintColor = .systemBlue

                }
            }}}
    
    //Cancel Button Settings
    func cancelButtonSettings()
    {
        cancelButtonTapped.addTarget(self, action: #selector(handleCancelButtonTapped), for: .touchUpInside)
        cancelButtonTapped.layer.borderColor = UIColor.systemBlue.cgColor
        cancelButtonTapped.layer.cornerRadius = 5
        cancelButtonTapped.layer.borderWidth = 1
    }
    // Cancel Button Handler
    @objc func handleCancelButtonTapped() { self.dismiss(animated: true, completion: nil) }
    
    
    // Add Button Settings
    func addButtonSettings()
    {
        addButtonTapped.addTarget(self, action: #selector(handleAddButtonTapped), for: .touchUpInside)
        addButtonTapped.tintColor = .systemBlue
        addButtonTapped.layer.borderColor = UIColor.systemBlue.cgColor
        addButtonTapped.layer.cornerRadius = 5
        addButtonTapped.layer.borderWidth = 1
    }
    

    // Add Button Handler
    @objc func handleAddButtonTapped()
    {
        if exerciseNameTextField.text!.isEmpty
        {
            exerciseNameTextField.shake()
            addOns.playSound(soundName: "Error Sound", delay: 0)
            
            addButtonTapped.shake()
            addButtonTapped.layer.borderColor = UIColor.systemRed.cgColor
            addButtonTapped.tintColor = .systemRed

            exerciseNameTextField.errorColor = .systemRed
            exerciseNameTextField.errorMessage = "Enter Exercise Name"

            if bodyPartNameTextField.text!.isEmpty
            {
                bodyPartNameTextField.shake()
                addOns.playSound(soundName: "Error Sound", delay: 0)
                
                addButtonTapped.shake()
                addButtonTapped.layer.borderColor = UIColor.systemRed.cgColor
                addButtonTapped.tintColor = .systemRed

                bodyPartNameTextField.errorColor = .systemRed
                bodyPartNameTextField.errorMessage = "Enter BodyPart Name"
            }
        }
        else if bodyPartNameTextField.text!.isEmpty
        {
            bodyPartNameTextField.shake()
            addOns.playSound(soundName: "Error Sound", delay: 0)
            
            addButtonTapped.shake()
            addButtonTapped.layer.borderColor = UIColor.systemRed.cgColor
            addButtonTapped.tintColor = .systemRed

            bodyPartNameTextField.errorColor = .systemRed
            bodyPartNameTextField.errorMessage = "Enter BodyPart Name"
        }
        else
        {
            newExercise.ExerciseName = exerciseNameTextField.text!
            newExercise.BodyPartName = bodyPartNameTextField.text!
            newExercise.CategoryName = categoryNameTextField?.text!

            exerciseNameTextField.errorMessage = ""
            bodyPartNameTextField.errorMessage = ""

            saveNewExercise(newExercise: newExercise)
            self.performSegue(withIdentifier: "goToBuildPlanVC", sender: self) //Exit to BuildPlanVC
            
        }
    }


    //Save Exercise to Realm DB
    func saveNewExercise(newExercise: Exercises)
    {
        do { try realm.write { realm.add(newExercise) } }
        catch { print("Error Saving New Exercise \(error)") }
    }
    
    //Dismiss Popup on touch outside of the popup
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
      {
          let touch = touches.first
        if touch?.view != labelStack && touch?.view != buttonStack && touch?.view != addLabel && touch?.view != self.popUpView
          { self.dismiss(animated: true, completion: nil) }
      }

}









