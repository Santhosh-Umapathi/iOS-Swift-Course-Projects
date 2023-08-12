//
//  CreateNewRoutineVC.swift
//  Fit City
//
//  Created by Santhosh Umapathi on 3/5/20.
//  Copyright © 2020 App City. All rights reserved.
//

import UIKit
import RealmSwift

class CreateRoutinePopUp: UIViewController
{
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var routineLabel: UILabel!
    
    @IBOutlet weak var routineNameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var popUpStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    
    
    let realm = try! Realm() //Realm Declaration
    var addOns = AddOns() //Implementing additional functions from Struct

    let newRoutine = UserRoutine() //UserRoutine Class Declaration

    override func viewDidLoad()
    {
        popUpViewSettings()
        saveButtonSettings()
        cancelButtonSettings()
        textfieldSettings()
    }
    
    func popUpViewSettings()
    { popUpView.layer.cornerRadius = 10 }
    
    func textfieldSettings()
    {
        routineNameTextField.delegate = self
        
        routineNameTextField.layer.borderWidth = 0.5
        routineNameTextField.layer.borderColor = UIColor(hexString: "E8E8E8").cgColor
        routineNameTextField.layer.cornerRadius = 10
        
        routineNameTextField.addTarget(self, action: #selector(routineNameTextFieldChanged(_:)), for: .editingChanged)
    }
    
    @objc func routineNameTextFieldChanged(_ textfield: UITextField)
    {
        if let text = textfield.text
        {
            if text.isEmpty
            {
                routineNameTextField.layer.borderColor = UIColor.systemRed.cgColor
                saveButton.setTitleColor(UIColor.systemRed, for: .normal)
            }
            else // The error message will only disappear when we reset it to nil or empty string
            {
                routineNameTextField.layer.borderColor = UIColor(hexString: "E8E8E8").cgColor
                saveButton.setTitleColor(UIColor(hexString: "007AFF"), for: .normal)
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        routineNameTextField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    //Save Routine to Realm DB
    func saveNewRoutine(newRoutine: UserRoutine)
    {
        do { try realm.write { realm.add(newRoutine) }}
        catch { print("Error Saving New Routine \(error)") }
    }
    
    
    func saveButtonSettings()
    { saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside) }

    @objc func handleSaveButton()
    {
        if routineNameTextField.text!.isEmpty
        {
            routineNameTextField.shake()
            routineNameTextField.layer.borderColor = UIColor.systemRed.cgColor
            
            saveButton.shake()
            saveButton.setTitleColor(UIColor.red, for: .normal)
            
            addOns.playSound(soundName: "Error Sound", delay: 0)
        }
        else
        {
            newRoutine.RoutineName = routineNameTextField.text!
            saveNewRoutine(newRoutine: self.newRoutine)
            
            self.performSegue(withIdentifier: "exitToAddRoutineViewController", sender: self) //Exit to BuildPlanVC
        }
        
        
        
    
    }
    
    
    func cancelButtonSettings()
    { cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside) }
      
    @objc func handleCancelButton()
    { self.dismiss(animated: true, completion: nil) }
    
    
    
    
    //Dismiss Popup on touch outside of the popup
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != popUpStack && touch?.view != buttonStack && touch?.view != self.popUpView && touch?.view != routineLabel
        { self.dismiss(animated: true, completion: nil) }
    }
    
}
