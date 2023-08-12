//  ProfileSettingsVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 2/10/20.
//  Copyright © 2020 App City. All rights reserved.

import Foundation
import UIKit
import SkyFloatingLabelTextField
import RealmSwift
import Firebase

class ProfileSettingsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var firstName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var lastName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var gender: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var dateOfBirth: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!

    @IBOutlet weak var resetPasswordButton: UIButton!
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightUnit: UILabel!
    @IBOutlet weak var weightUnit: UILabel!
    
    
    @IBOutlet weak var fitnessGoal: UITextField!
    @IBOutlet weak var bmi: UILabel!
    @IBOutlet weak var calories: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    let realm = try! Realm()
    var userArray: Results<UserDatabase>!
    let updateUser = UserDatabase()
    
    var userEmail = UserDefaults.standard.value(forKey: "userEmail") //Getting user email from Login/Signup Screen
    
    var addOns = AddOns()
    
    
    
    @IBAction func heightSliderChanged(_ sender: UISlider)
    {
        heightLabel.text = String(format: "%.0f", sender.value)
        calculateBMI()
        calculateCalories()
    }
    
    
    @IBAction func weightSliderChanged(_ sender: UISlider)
    {
        weightLabel.text = String(format: "%.0f", sender.value)
        calculateBMI()
        calculateCalories()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        textfieldLabelSettings()
        cancelButtonSettings()
        fitnessGoalPickerSettings()
        getUserInfo()
        genderPickerSettings()
        dateOfBirthPickerSettings()
        saveButtonSettings()
        profileImageSettings()
        
        
    }
    
    
    
    
    //MARK: - Get User Info
    func getUserInfo()
    {
        if let userDetails = try! Realm().objects(UserDatabase.self).filter("Email == %@", self.userEmail!).first
        {
            self.profileImage.image = UIImage(data: userDetails.ProfileImage)
            self.firstName.text = userDetails.FirstName
            self.lastName.text = userDetails.LastName
            self.gender.text = userDetails.Gender
            self.dateOfBirth.text = userDetails.DateOfBirth
            self.email.text = userDetails.Email
            self.heightLabel.text = String(userDetails.Height)
            self.weightLabel.text = String(userDetails.Weight)
            
            self.bmi.text = String(userDetails.BMI)
            self.fitnessGoal.text = userDetails.FitnessGoal
            self.calories.text = String(userDetails.Calories)
        }
    }

    
    //MARK: - Fitness Goal Picker Settings
    var fitnessGoalPicker = UIPickerView()
    var fitnessGoalArray = ["Maintain Body", "Gain Muscle", "Lose Weight"]
    
    func fitnessGoalPickerSettings()
    {   //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFitnessGoalPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelFitnessGoalPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: true)
        
        fitnessGoal.inputAccessoryView = toolbar
        fitnessGoal.inputView = fitnessGoalPicker
        fitnessGoal.tintColor = .white
        
        fitnessGoalPicker.delegate = self
        fitnessGoalPicker.dataSource = self
        fitnessGoalPicker.backgroundColor = .clear
    }
    
    @objc func doneFitnessGoalPicker()
    {
        if fitnessGoal.text! == "--" { fitnessGoal.text = fitnessGoalArray[0] }
        self.view.endEditing(true)
    }

    @objc func cancelFitnessGoalPicker() { self.view.endEditing(true) }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == fitnessGoalPicker { return fitnessGoalArray.count }
        else { return genderArray.count }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == fitnessGoalPicker
        {
            fitnessGoal.text = fitnessGoalArray[row] ; calculateCalories()
        }
        else
        {
            gender.text = genderArray[row]
            gender.errorMessage = ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == fitnessGoalPicker
        {
            return "\(fitnessGoalArray[row])"
        }
        else //pickerView == genderPicker
        {
            return "\(genderArray[row])"
        }
        
    }
    
    
    //MARK: - BMI & Calories Calculator
    // BMI Calculator
    func calculateBMI()
    {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        let heightValue = height / 100
        let heightValue2 = heightValue * heightValue
        let bmiValue = weight / heightValue2

        if bmiValue < 18.5
        {
            bmi.text = String(format: "%.1f", bmiValue)
            bmi.textColor = .red
        }
        else if bmiValue < 24.9
        {
            bmi.text = String(format: "%.1f", bmiValue)
            bmi.textColor = .darkGray
        }
        else
        {
            bmi.text = String(format: "%.1f", bmiValue)
            bmi.textColor = .systemGreen
        }
    }
    
    //Calories calculator
    func calculateCalories()
    {
        var height = heightSlider.value
        var weight = weightSlider.value
        var age = addOns.calcAge(birthday: dateOfBirth.text!)
        
        if gender.text == "Male" && fitnessGoal.text == "Maintain Body" || fitnessGoal.text!.isEmpty
        {
            weight = 10 * weight
            height = 6.25 * height
            age = 5 * age
            let menCalories = weight + height - Float(age) + 5
            
            calories.text = String(format: "%.0f",menCalories)
        }
        else if gender.text == "Male" && fitnessGoal.text == "Gain Muscle"
        {
            weight = 10 * weight
            height = 6.25 * height
            age = 5 * age
            let menCalories = weight + height - Float(age) + 5 + 500
            
            calories.text = String(format: "%.0f",menCalories)
        }
        else if gender.text == "Male" && fitnessGoal.text == "Lose Weight"
        {
            weight = 10 * weight
            height = 6.25 * height
            age = 5 * age
            let menCalories = weight + height - Float(age) + 5 - 500
            
            calories.text = String(format: "%.0f",menCalories)
        }
            
        else if gender.text == "Female" && fitnessGoal.text == "Maintain Body" || fitnessGoal.text!.isEmpty
        {
            weight = 10 * weight
            height = 6.25 * height
            age = 5 * age
            let womenCalories = weight + height - Float(age) - 161
            
            calories.text = String(format: "%.0f",womenCalories)
        }
        else if gender.text == "Female" && fitnessGoal.text == "Gain Muscle"
        {
            weight = 10 * weight
            height = 6.25 * height
            age = 5 * age
            let womenCalories = weight + height - Float(age) - 161 + 500
            
            calories.text = String(format: "%.0f",womenCalories)
        }
        else if gender.text == "Female" && fitnessGoal.text == "Lose Weight"
        {
            weight = 10 * weight
            height = 6.25 * height
            age = 5 * age
            let womenCalories = weight + height - Float(age) - 161 - 500
            
            calories.text = String(format: "%.0f",womenCalories)
        }
    }
    
    //MARK: - Label / Textfield Border Settings
    func textfieldLabelSettings()
    {
        firstName.addTarget(self, action: #selector(firstNameTextFieldChanged), for: .editingChanged)
        lastName.addTarget(self, action: #selector(lastNameTextFieldChanged), for: .editingChanged)
        gender.addTarget(self, action: #selector(genderTextFieldChanged), for: .editingChanged)
        dateOfBirth.addTarget(self, action: #selector(dobTextFieldChanged), for: .editingChanged)
        email.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)

        
        
        
        //Height value field
        heightLabel.layer.borderColor = UIColor.darkGray.cgColor
        heightLabel.layer.borderWidth = 0.5
        heightLabel.layer.cornerRadius = 4
       
//        let heightTap = UITapGestureRecognizer(target: self, action: #selector(heightGesture))
//        heightLabel.isUserInteractionEnabled = true
//        heightLabel.addGestureRecognizer(heightTap)
           
        
        //Weight value field
        weightLabel.layer.borderColor = UIColor.darkGray.cgColor
        weightLabel.layer.borderWidth = 0.5
        weightLabel.layer.cornerRadius = 4
//
//        let weightTap = UITapGestureRecognizer(target: self, action: #selector(weightGesture))
//        heightLabel.isUserInteractionEnabled = true
//        heightLabel.addGestureRecognizer(weightTap)
        
        //Fitness Goal value Field
        fitnessGoal.layer.borderColor = UIColor.darkGray.cgColor
        fitnessGoal.layer.borderWidth = 0.5
        fitnessGoal.layer.cornerRadius = 4
        
        //BMI value field
        bmi.layer.borderColor = UIColor.darkGray.cgColor
        bmi.layer.cornerRadius = 4
        bmi.layer.borderWidth = 0.5
        
        //Calories value field
        calories.layer.borderColor = UIColor.darkGray.cgColor
        calories.layer.cornerRadius = 4
        calories.layer.borderWidth = 0.5
    }
    
//    @objc func heightGesture()
//    {
//        if heightLabel.text!.contains("Cm")
//        {
//            let height = String(format: "%.0f", sender.value)
//            heightLabel.text = "\(height)In"
//        }
//    }
//
//    @objc func weightGesture()
//    {
//
//    }
    
    
    
    //Cancel Button Settings
    func cancelButtonSettings()
    {
        cancelButton.addTarget(self, action: #selector(handleCancelButtonTapped), for: .touchUpInside)
        cancelButton.layer.borderColor = UIColor.systemBlue.cgColor
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
    }
    // Cancel Button Handler
    @objc func handleCancelButtonTapped() { self.dismiss(animated: true, completion: nil) }
    
    
    var imagePicker: UIImagePickerController!
    var genderPicker = UIPickerView()
    var genderArray = ["Male", "Female"]
    var datePicker = UIDatePicker()
    
    //Save Exercise to Realm DB
    func updateUserDetails(updateUser: UserDatabase)
    {
        do { try realm.write { realm.add(updateUser) } }
        catch { print("Error Updating User \(error)") }
    }
    
    //Delete previous user details from Realm DB
    func deleteUserDetails(updateUser: UserDatabase)
    {
        do { try realm.write { realm.delete(updateUser) } }
        catch { print("Error Deleting User Details \(error)") }
    }
    
    //MARK: - Date Of Birth Picker Settings
       func dateOfBirthPickerSettings()
       {
           datePicker.datePickerMode = .date //Format Date

           //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

           toolbar.setItems([cancelButton,spaceButton,doneButton], animated: true)

           dateOfBirth.inputAccessoryView = toolbar
           dateOfBirth.inputView = datePicker
       }
    
    @objc func doneDatePicker()
      {
          let formatter = DateFormatter()
          formatter.dateFormat = "MM/dd/yyyy"
          dateOfBirth.text = formatter.string(from: datePicker.date)
          if addOns.calcAge(birthday: dateOfBirth.text!) <= 13
          {
              dateOfBirth.errorMessage = "Min Age 14yrs"
              dateOfBirth.text = nil
              self.view.endEditing(false)
          }
          else
          {
              self.view.endEditing(true)
              dateOfBirth.errorMessage = ""
          }
         
      }

      @objc func cancelDatePicker() { self.view.endEditing(true) }
    
    
    
    //MARK: - Gender Picker Settings
     func genderPickerSettings()
     {   //ToolBar
         let toolbar = UIToolbar();
         toolbar.sizeToFit()
         let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneGenderPicker));
         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelGenderPicker));

         toolbar.setItems([cancelButton,spaceButton,doneButton], animated: true)
         
         gender.inputAccessoryView = toolbar
         gender.inputView = genderPicker
         
         genderPicker.delegate = self
         genderPicker.dataSource = self
         genderPicker.backgroundColor = .clear
     }
     
     @objc func doneGenderPicker()
     {
         if gender.text!.isEmpty
         {
             gender.text = genderArray[0]
             gender.errorMessage = ""
         }
         self.view.endEditing(true)
     }

     @objc func cancelGenderPicker() { self.view.endEditing(true) }
     
     
    
    
    //Save Button Settings
       func saveButtonSettings()
       {
           saveButton.layer.borderColor = UIColor.systemBlue.cgColor
           saveButton.layer.cornerRadius = 5
           saveButton.layer.borderWidth = 1
        
           saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
       }
    
    
    //Save Button Handler
    @objc func handleSave()
    {
        
        // All Fields Empty
        if firstName.text!.isEmpty
        {
            firstName.shake()
            addOns.playSound(soundName: "Error Sound", delay: 0)
            
            
            saveButton.shake()
            saveButton.layer.borderColor = UIColor.systemRed.cgColor

            
            firstName.errorColor = .systemRed
            firstName.errorMessage = "Enter First Name"
            
            if lastName.text!.isEmpty
            {
                lastName.shake()
                addOns.playSound(soundName: "Error Sound", delay: 0)

                saveButton.shake()
                saveButton.layer.borderColor = UIColor.systemRed.cgColor

                
                lastName.errorColor = .systemRed
                lastName.errorMessage = "Enter Last Name"
                
                if gender.text!.isEmpty
                {
                    gender.shake()
                    addOns.playSound(soundName: "Error Sound", delay: 0)

                    saveButton.shake()
                    saveButton.layer.borderColor = UIColor.systemRed.cgColor

                    
                    gender.errorColor = .systemRed
                    gender.errorMessage = "Enter Gender"
                    
                    if dateOfBirth.text!.isEmpty
                    {
                        dateOfBirth.shake()
                        addOns.playSound(soundName: "Error Sound", delay: 0)

                        saveButton.shake()
                        saveButton.layer.borderColor = UIColor.systemRed.cgColor

                        
                        dateOfBirth.errorColor = .systemRed
                        dateOfBirth.errorMessage = "Enter D.O.B"
                        
                        if email.text!.isEmpty
                        {
                            email.shake()
                            addOns.playSound(soundName: "Error Sound", delay: 0)

                            saveButton.shake()
                            saveButton.layer.borderColor = UIColor.systemRed.cgColor

                            
                            email.errorColor = .systemRed
                            email.errorMessage = "Enter Email ID"
                            
                        }}}}}
        
        
        
        // LastName, Gender, DOB, Email , Password empty
        else if lastName.text!.isEmpty
        {
            lastName.shake()
            addOns.playSound(soundName: "Error Sound", delay: 0)

            saveButton.shake()
            saveButton.layer.borderColor = UIColor.systemRed.cgColor
            
            
            lastName.errorColor = .systemRed
            lastName.errorMessage = "Enter Last Name"
            
            if gender.text!.isEmpty
            {
                gender.shake()
                addOns.playSound(soundName: "Error Sound", delay: 0)

                saveButton.shake()
                saveButton.layer.borderColor = UIColor.systemRed.cgColor
                
                
                gender.errorColor = .systemRed
                gender.errorMessage = "Enter Gender"
                
                if dateOfBirth.text!.isEmpty
                {
                    dateOfBirth.shake()
                    addOns.playSound(soundName: "Error Sound", delay: 0)

                    saveButton.shake()
                    saveButton.layer.borderColor = UIColor.systemRed.cgColor
                    
                    
                    dateOfBirth.errorColor = .systemRed
                    dateOfBirth.errorMessage = "Enter D.O.B"
                    
                    if email.text!.isEmpty
                    {
                        email.shake()
                        addOns.playSound(soundName: "Error Sound", delay: 0)

                        saveButton.shake()
                        saveButton.layer.borderColor = UIColor.systemRed.cgColor
                        
                        
                        email.errorColor = .systemRed
                        email.errorMessage = "Enter Email ID"
                        
                    }}}}
            
        // Gender, DOB, Email, Password empty
        else if gender.text!.isEmpty
        {
            gender.shake()
            addOns.playSound(soundName: "Error Sound", delay: 0)

            saveButton.shake()
            saveButton.layer.borderColor = UIColor.systemRed.cgColor
            
            
            gender.errorColor = .systemRed
            gender.errorMessage = "Enter Gender"
            
            if dateOfBirth.text!.isEmpty
            {
                dateOfBirth.shake()
                addOns.playSound(soundName: "Error Sound", delay: 0)

                saveButton.shake()
                saveButton.layer.borderColor = UIColor.systemRed.cgColor
                
                
                dateOfBirth.errorColor = .systemRed
                dateOfBirth.errorMessage = "Enter D.O.B"
                
                if email.text!.isEmpty
                {
                    email.shake()
                    addOns.playSound(soundName: "Error Sound", delay: 0)

                    saveButton.shake()
                    saveButton.layer.borderColor = UIColor.systemRed.cgColor
                    
                    
                    email.errorColor = .systemRed
                    email.errorMessage = "Enter Email ID"
                    
                }}}
        
        // DOB, Email, Password empty
        else if dateOfBirth.text!.isEmpty //|| addOns.calcAge(birthday: dateOfBirth.text!) <= 14
        {
            dateOfBirth.shake()
            addOns.playSound(soundName: "Error Sound", delay: 0)

            saveButton.shake()
            saveButton.layer.borderColor = UIColor.systemRed.cgColor
            
            
            dateOfBirth.errorColor = .systemRed
            dateOfBirth.errorMessage = "Enter D.O.B"
            
            if email.text!.isEmpty
            {
                email.shake()
                addOns.playSound(soundName: "Error Sound", delay: 0)

                saveButton.shake()
                saveButton.layer.borderColor = UIColor.systemRed.cgColor
                
                
                email.errorColor = .systemRed
                email.errorMessage = "Enter Email ID"
                
            }}
        
        // Email, Password empty
        else if email.text!.isEmpty
        {
                email.shake()
            addOns.playSound(soundName: "Error Sound", delay: 0)

                saveButton.shake()
                saveButton.layer.borderColor = UIColor.systemRed.cgColor
                
                
                email.errorColor = .systemRed
                email.errorMessage = "Enter Email ID"
        }
            
        // Email not contain "@", Password Empty
        else if !email.text!.contains("@") || !email.text!.contains(".")
        {
            
            email.shake()
            addOns.playSound(soundName: "Error Sound", delay: 0)

            saveButton.shake()
            saveButton.layer.borderColor = UIColor.systemRed.cgColor
            
            email.errorColor = .systemRed
            email.errorMessage = "Invalid Email"
        }
            
        // All Fields Good
        else
        {
            firstName.errorMessage = ""
            lastName.errorMessage = ""
            gender.errorMessage = ""
            dateOfBirth.errorMessage = ""
            email.errorMessage = ""
            
            //Realm Database Image saved as Data
            guard let profileImageRD = profileImage.image?.pngData() else {return}
            guard let profileImageFB = profileImage.image else {return}
            guard let firstnameFB = firstName.text else {return}
            guard let lastnameFB = lastName.text else {return}
            guard let genderFB = gender.text else {return}
            guard let dateofbirthFB = dateOfBirth.text else {return}
            guard let emailFB = email.text else {return}
            guard let heightFB = Int(heightLabel.text!) else {return}
            guard let weightFB = Int(weightLabel.text!) else {return}
            guard let bmiFB = Double(bmi.text!) else {return}
            guard let fitnessGoalFB = fitnessGoal.text else {return}
            guard let caloriesFB = Int(calories.text!) else {return}

            updateUser.ProfileImage = profileImageRD
            updateUser.FirstName = firstnameFB
            updateUser.LastName = lastnameFB
            updateUser.Gender = genderFB
            updateUser.DateOfBirth = dateofbirthFB
            updateUser.Email = emailFB
            
            updateUser.Height = heightFB
            updateUser.Weight = weightFB
            updateUser.BMI = bmiFB
            updateUser.FitnessGoal = fitnessGoalFB
            updateUser.Calories = caloriesFB
            
            if let userDetails = try! Realm().objects(UserDatabase.self).filter("Email == %@", self.userEmail!).first
            {
                let passwordFB = userDetails.Password
                updateUser.Password = passwordFB
                
                updateFirebaseUserDetails(firstnameFB: firstnameFB, lastnameFB: lastnameFB, genderFB: genderFB, dateofbirthFB: dateofbirthFB, emailFB: emailFB, passwordFB: passwordFB, profileImageFB: profileImageFB)
                
                updateFirebaseAuthentication(authEmail: emailFB, email: userEmail as! String, password: passwordFB)
                
                UserDefaults.standard.set(emailFB, forKey: "userEmail")
                
                deleteUserDetails(updateUser: userDetails) //Realm user previous details deleted
            }
                updateUserDetails(updateUser: updateUser) // Realm user db updated

            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "goToStartWorkoutVC", sender: self) //Exit to StartWorkoutVC
        }
    }
    
    //Text Field Handlers
    @objc func firstNameTextFieldChanged(_ textfield: UITextField)
    {
        if let text = textfield.text
        {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField
            {
                if text.isEmpty
                {    floatingLabelTextField.errorMessage = "Enter First Name"
                    saveButton.layer.borderColor = UIColor.systemRed.cgColor
                    saveButton.shake()
                }
                else // The error message will only disappear when we reset it to nil or empty string
                {    floatingLabelTextField.errorMessage = ""
                    saveButton.layer.borderColor = UIColor.systemBlue.cgColor
                }}}}
    
    @objc func lastNameTextFieldChanged(_ textfield: UITextField)
    {
        if let text = textfield.text
        {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField
            {
                if text.isEmpty
                {   floatingLabelTextField.errorMessage = "Enter Last Name"
                    saveButton.layer.borderColor = UIColor.systemRed.cgColor
                    saveButton.shake()
                }
                else // The error message will only disappear when we reset it to nil or empty string
                {   floatingLabelTextField.errorMessage = ""
                    saveButton.layer.borderColor = UIColor.systemBlue.cgColor
                }}}}
    
    @objc func genderTextFieldChanged(_ textfield: UITextField)
    {
        if let text = textfield.text
        {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField
            {
                if text.isEmpty
                {   floatingLabelTextField.errorMessage = "Enter Gender"
                    saveButton.layer.borderColor = UIColor.systemRed.cgColor
                    saveButton.shake()
                }
                else // The error message will only disappear when we reset it to nil or empty string
                {   floatingLabelTextField.errorMessage = ""
                    saveButton.layer.borderColor = UIColor.systemBlue.cgColor
                }}}}
    
    @objc func dobTextFieldChanged(_ textfield: UITextField)
    {
        if let text = textfield.text
        {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField
            {
                if text.isEmpty
                {    floatingLabelTextField.errorMessage = "Enter D.O.B"
                    saveButton.layer.borderColor = UIColor.systemRed.cgColor
                    saveButton.shake()
                }
                else // The error message will only disappear when we reset it to nil or empty string
                {    floatingLabelTextField.errorMessage = ""
                    saveButton.layer.borderColor = UIColor.systemBlue.cgColor
                }}}}
    
    
    @objc func emailTextFieldChanged(_ textfield: UITextField)
    {
        if let text = textfield.text
        {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField
            {
                if text.isEmpty  //(|| !text.contains("@"))
                {   floatingLabelTextField.errorMessage = "Enter valid Email ID"
                    saveButton.shake()
                    saveButton.layer.borderColor = UIColor.systemRed.cgColor
                }
                else // The error message will only disappear when we reset it to nil or empty string
                {   floatingLabelTextField.errorMessage = ""
                    saveButton.layer.borderColor = UIColor.systemBlue.cgColor
                }}}}
    
    
    //MARK: - Firebase User Details Upload
    
    func updateFirebaseUserDetails(firstnameFB: String, lastnameFB: String, genderFB: String, dateofbirthFB: String, emailFB: String, passwordFB: String, profileImageFB: UIImage)
    {
        Auth.auth().updateCurrentUser(Auth.auth().currentUser!, completion:
        { (error) in
                if error != nil { print("Failed to Update User Details:", error!.localizedDescription); return }
        })
                    // Upload image to Firebase
                    uploadProfileImage(profileImageFB)
                    { (url) in if url != nil
                    {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.photoURL = url
                        changeRequest?.commitChanges(completion:
                            { (error) in if error == nil
                            {
                                self.updateUserDetails(firstname: firstnameFB, lastname: lastnameFB, gender: genderFB, dateofbirth: dateofbirthFB, email: emailFB, password: passwordFB, profileImageURL: url!)
                                { (success) in if success {  } }
                            } else { print(error!.localizedDescription) }
                            })
                    }
                    }
    }
        
    //Update User Authentication in Firebase
    func updateFirebaseAuthentication(authEmail: String, email: String, password: String)
    {
        let currentUser = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
       
        //Reauthenticate current user before email update times out in firebase
        currentUser?.reauthenticate(with: credential, completion:
        { (result, error) in
            if error != nil { print("Error updating User Auth", error!) }
            else
            {
                currentUser?.updateEmail(to: authEmail, completion:
                { (error) in
                    if error != nil { print("Error updating User Auth", error!) }
                    else
                    {
                        print("Auth Email Updated")
                        let uid = Auth.auth().currentUser!.uid
                        let thisUserRef = Database.database().reference().child("Users").child(uid)
                        let thisUserEmailRef = thisUserRef.child("email")
                        thisUserEmailRef.setValue(authEmail)
                    }
                })
            }
        })
            
//        //Update user auth email in firebase
//        currentUser?.updateEmail(to: email)
//        { error in
//            if error != nil { print("Error updating User Auth", error!) }
//            else
//            {
//                print("Auth Email Updated")
//                let uid = Auth.auth().currentUser!.uid
//                let thisUserRef = Database.database().reference().child("Users").child(uid)
//                let thisUserEmailRef = thisUserRef.child("email")
//                thisUserEmailRef.setValue(email)
//            }
//        }
    }
        
    
    //MARK: - Upload User Image to Firebase Storage
    func uploadProfileImage(_ image : UIImage, completion: @escaping ((_ url:URL?)->()))
    {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}

        let storageRef = Storage.storage().reference().child("User/\(uid)")

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
//        storageRef.delete
//        { (error) in if error != nil { print("Error Deleting previous user image", error!) } }

        storageRef.putData(imageData, metadata: metaData)
        {   metaData, error in
            if error == nil, metaData != nil
            {   //Success
                storageRef.downloadURL(completion:
                {   (url, error) in
                    if error != nil { completion(nil) }
                    else { completion(url?.absoluteURL) }
                 })
            } else { completion(nil) } // Failed
        }
    }
    
    //MARK: - Update User details & update values to Firebase DB
    func updateUserDetails(firstname: String, lastname: String, gender: String, dateofbirth: String, email: String, password: String, profileImageURL : URL, completion: @escaping ((_ success:Bool)->()))
    {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("Users/\(uid)")

        //Updating Value names for Firebase DB
        let values = ["FirstName" : firstname, "LastName" : lastname, "Gender" : gender, "DateOfBirth" : dateofbirth, "Email" : email, "Password" : password, "ProfileImageURL" : profileImageURL.absoluteString] as [String:Any]

        // Adding/Updating values to FireBase DB
        databaseRef.setValue(values)
        { error, ref in
            if error != nil { print("Failed to Update User Details:", error!.localizedDescription); return }
        }
        print("User details updated in Firebase")
    }
}

//MARK: - Image Picker Serttings
extension ProfileSettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true, completion: nil) } // Cancel Image Picker
    
    //Choose Image from Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        { self.profileImage.image = pickedImage }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Image Picker Settings
    func profileImageSettings()
    {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func openImagePicker(_ sender:Any) { self.present(imagePicker, animated: true, completion: nil) } // Open Image Picker
}
