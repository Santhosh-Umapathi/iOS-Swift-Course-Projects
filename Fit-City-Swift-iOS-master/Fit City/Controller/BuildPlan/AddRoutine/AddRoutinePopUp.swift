//
//  AddRoutineViewController.swift
//  Fit City
//
//  Created by Santhosh Umapathi on 2/24/20.
//  Copyright © 2020 App City. All rights reserved.
//

import UIKit
import RealmSwift

class AddRoutinePopUp: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var createNewRoutine: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButtonTapped: UIButton!
    @IBOutlet weak var popUpStack: UIStackView!
    @IBOutlet weak var collectionStack: UIStackView!
    
    //Segue for Exit from AddNewExerciseVC & Reload BuildPlanVC
    @IBAction func exitToAddRoutineViewController(segue: UIStoryboardSegue)
    {
        DispatchQueue.global(qos: .userInitiated).async
        { DispatchQueue.main.async { self.collectionView.reloadData() } }
    }
    
    let cellID = "addRoutineCell"
    
    let realm = try! Realm()
    
    var userRoutine: Results<UserRoutine>?
    let newRoutine = UserRoutine() //UserRoutine Class Declaration

    
    var sectionNames: [String]?
    {
        userRoutine = try! Realm().objects(UserRoutine.self)
        let sectionKeys =  Set(userRoutine?.value(forKeyPath: "RoutineName") as! [String]).sorted()
        return sectionKeys
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    { collectionView.reloadData() }
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        customViewSettings()
        collectionViewSettings()

        createRoutineButtonSettings()
        closeButtonSettings()
            

    }
    
    func customViewSettings()
    { customView.layer.cornerRadius = 10 }

    
    func createRoutineButtonSettings()
    {
        createNewRoutine.layer.cornerRadius = 10
        createNewRoutine.backgroundColor = UIColor(hexString: "C6E6FF")
        createNewRoutine.setTitleColor(UIColor(hexString: "2F84FF"), for: .normal)
    }
    

    
    @objc func createButtonHandler()
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Routine Name", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default)
        { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            
            self.newRoutine.RoutineName = textField.text!
            self.saveNewRoutine(newRoutine: self.newRoutine)
            
            
        }
        
        alert.addTextField
        { (alertTextField) in
            alertTextField.placeholder = "Routine Name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))

        
        present(alert, animated: true, completion: nil)
 
    }
    
    
    //Save Exercise to Realm DB
      func saveNewRoutine(newRoutine: UserRoutine)
      {
          do { try realm.write { realm.add(newRoutine) }
          }
          catch { print("Error Saving New Routine \(error)") }
      }
    
    
    
    func collectionViewSettings()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "AddRoutineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.reloadData() //Reload CollectionView Data
    }
    
    func closeButtonSettings()
    {
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeButtonHandler))
        closeButtonTapped.addGestureRecognizer(closeTap)
    }
    
    @objc func closeButtonHandler()
    {
        self.dismiss(animated: true, completion: nil)
    }

    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if sectionNames?.count == 0 { return 1 }
        else
        {
            return sectionNames!.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AddRoutineCollectionViewCell
        
        
        userRoutine = try! Realm().objects(UserRoutine.self).sorted(byKeyPath: "RoutineName")
        
        
        if userRoutine?.count != 0
        {
            if let items = userRoutine?[indexPath.row]
            {
                collectionCell.isUserInteractionEnabled = true
                collectionCell.routineName.text = items.RoutineName
                collectionCell.routineName.textAlignment = .center
            }
        }
        else
        {
            collectionCell.isUserInteractionEnabled = false
            collectionCell.routineName.text = "No Rountines Added Yet"
            collectionCell.routineName.textAlignment = .center
        }
        return collectionCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        userRoutine = try! Realm().objects(UserRoutine.self).sorted(byKeyPath: "RoutineName")
        print(userRoutine?[indexPath.row].RoutineName ?? "Null")
    }
    
    
    
   
    
    //Dismiss Popup on touch outside of the popup
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != popUpStack && touch?.view != collectionStack
        { self.dismiss(animated: true, completion: nil) }
    }
    
    
}
