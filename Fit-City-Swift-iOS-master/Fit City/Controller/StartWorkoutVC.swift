//  StartWorkoutVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 11/23/19.
//  Copyright © 2019 App City. All rights reserved.

import UIKit
import Firebase
import RealmSwift

// Workout Containers, Add new Rountine button

class StartWorkoutVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fNameLName: UILabel!
    
    let realm = try! Realm()
    var userArray: Results<UserDatabase>!
    
    
    var userEmail = UserDefaults.standard.value(forKey: "userEmail")
    
    
    
    fileprivate let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white //UIColor(hexString: "B6D7FF")
        return cv
    }()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    { super.viewDidAppear(animated)
        collectionView.reloadData()

    }
    
    
    
    //Segue for Exit from AddNewExerciseVC & Reload BuildPlanVC
    @IBAction func exitToStartWorkoutVC(segue: UIStoryboardSegue)
    {
       DispatchQueue.global(qos: .userInitiated).async
        {
            self.getUserInforFromRealmDB()
            //self.getUserInfoFromFirebaseDB()
        }
    }
    
    
    
    
    func profileSettingsPage()
    {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(openProfileSettingsVC))
        fNameLName.isUserInteractionEnabled = true
        fNameLName.addGestureRecognizer(profileTap)
    }
    
    
    @objc func openProfileSettingsVC()
    {
        let profileSettingsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSettingsVC")
        present(profileSettingsVC!, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad()
    {
        getUserInforFromRealmDB()
        //getUserInfoFromFirebaseDB()
        //print("Screen Entered \(userEmail)")
        profileImageSettings()
        profileSettingsPage()
        nameAnimation()
        
        collectionViewSettings()
        //view.backgroundColor = UIColor(hexString: "B6D7FF")
    }
    
    func collectionViewSettings()
    {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.width/1.5).isActive = true

        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "StartWorkoutVCCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        collectionView.reloadData() //Reload CollectionView Data
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    { return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/1.5) } //2.3
    
    //MARK: - User info from Firebase DB
    func getUserInfoFromFirebaseDB()
    {
        let firebaseDB = Database.database().reference()
        
        guard let uid = Auth.auth().currentUser?.uid else {return} //Getting current User ID
        
        firebaseDB.child("Users").child(uid).observe(.value)
        { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any]
            {   //Retrieving Values from FireBase DB for the User
                let profileImageURLFB = dictionary["ProfileImageURL"] as! String
                let fNameFB = dictionary["FirstName"] as! String
                let lNameFB = dictionary["LastName"] as! String
                
                self.fNameLName.alpha = 0
                UIView.animate(withDuration: 0.5)
                {
                    self.fNameLName.text = "\(fNameFB) \(lNameFB)" //Displaying User Name
                    self.fNameLName.alpha = 1
                }
                self.profileImage.loadImageWithCacheUsingURLString(URLString: profileImageURLFB) //Displaying User Image
            }
        }
    }
    
    //MARK: - User info from Realm DB
    func getUserInforFromRealmDB()
    {
//        DispatchQueue.main.async
//        {
        if let userDetails = try! Realm().objects(UserDatabase.self).filter("Email == %@", self.userEmail!).first
                {
                        self.fNameLName.text = "\(userDetails.FirstName) \(userDetails.LastName)"
                        self.profileImage.image = UIImage(data: userDetails.ProfileImage)
                }
       // }
    }

    
    func profileImageSettings()
    {
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = self.profileImage.bounds.height / 2
        profileImage.contentMode = .scaleAspectFit
    }
    
    func nameAnimation()
    {
        fNameLName.alpha = 0
        UIView.animate(withDuration: 1)
        { self.fNameLName.alpha = 1 }
    }
   
    
    var userRoutine: Results<UserRoutine>?
    
    var sectionNames: [String]?
    {
        userRoutine = try! Realm().objects(UserRoutine.self)
        let sectionKeys =  Set(userRoutine?.value(forKeyPath: "RoutineName") as! [String]).sorted()
        return sectionKeys
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if sectionNames?.count == 0 { return 1 }
        else { return sectionNames!.count }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! StartWorkoutVCCollectionViewCell
        
        userRoutine = try! Realm().objects(UserRoutine.self).sorted(byKeyPath: "RoutineName")
        
        if userRoutine?.count != 0
        {
            if let items = userRoutine?[indexPath.row]
            {
                if items.RoutineExercises.isEmpty
                {
                    collectionCell.routineName.text = items.RoutineName
                    collectionCell.ex1.text = ""
                    collectionCell.ex2.text = ""
                    collectionCell.ex3.text = "No Exercises Added Yet"
                    collectionCell.ex4.text = ""
                    collectionCell.ex5.text = ""
                    

                    collectionCell.startWokroutTapped.isHidden = true
                    collectionCell.ex3.textAlignment = .center
                }
//                else if items.RoutineExercises[1].ExerciseName.isEmpty
//                {
//                    collectionCell.routineName.text = items.RoutineName
//                    collectionCell.ex1.text = "• \(items.RoutineExercises[0].ExerciseName)"
//                    collectionCell.ex2.text = ""
//                    collectionCell.ex3.text = ""
//                    collectionCell.ex4.text = ""
//                    collectionCell.ex5.text = ""
//                }
//                    else if items.RoutineExercises[2].ExerciseName.isEmpty
//                    {
//                        collectionCell.routineName.text = items.RoutineName
//                        collectionCell.ex1.text = "• \(items.RoutineExercises[0].ExerciseName)"
//                        collectionCell.ex2.text = "• \(items.RoutineExercises[1].ExerciseName)"
//                        collectionCell.ex3.text = ""
//                        collectionCell.ex4.text = ""
//                        collectionCell.ex5.text = ""
//                    }
//                    else if items.RoutineExercises[3].ExerciseName.isEmpty
//                    {
//                        collectionCell.routineName.text = items.RoutineName
//                        collectionCell.ex1.text = "• \(items.RoutineExercises[0].ExerciseName)"
//                        collectionCell.ex2.text = "• \(items.RoutineExercises[1].ExerciseName)"
//                        collectionCell.ex3.text = "• \(items.RoutineExercises[2].ExerciseName)"
//                        collectionCell.ex4.text = ""
//                        collectionCell.ex5.text = ""
//                    }
//                    else if items.RoutineExercises[4].ExerciseName.isEmpty
//                    {
//                        collectionCell.routineName.text = items.RoutineName
//                        collectionCell.ex1.text = "• \(items.RoutineExercises[0].ExerciseName)"
//                        collectionCell.ex2.text = "• \(items.RoutineExercises[1].ExerciseName)"
//                        collectionCell.ex3.text = "• \(items.RoutineExercises[2].ExerciseName)"
//                        collectionCell.ex4.text = "• \(items.RoutineExercises[3].ExerciseName)"
//                        collectionCell.ex5.text = ""
//                    }
                    
                else
                {
                    collectionCell.routineName.text = items.RoutineName
                    collectionCell.ex1.text = "• \(items.RoutineExercises[0].ExerciseName)"
                    collectionCell.ex2.text = "• \(items.RoutineExercises[1].ExerciseName)"
                    collectionCell.ex3.text = "• \(items.RoutineExercises[2].ExerciseName)"
                    collectionCell.ex4.text = "• \(items.RoutineExercises[3].ExerciseName)"
                    collectionCell.ex5.text = "• \(items.RoutineExercises[4].ExerciseName)"
                    
                    collectionCell.startWokroutTapped.isHidden = false
                    collectionCell.ex3.textAlignment = .left
                }
               
                collectionCell.isUserInteractionEnabled = true
                collectionCell.deleteButtonTapped.isHidden = false
                
                collectionCell.deleteButtonTapped.tag = indexPath.item //Settings the selected item indexpath to button
                collectionCell.deleteButtonTapped.addTarget(self,action: #selector(deleteButtonTappedHandler(_:)),for: .touchUpInside)
            }
        }
        else
        {
            collectionCell.isUserInteractionEnabled = false
            collectionCell.ex3.textAlignment = .center
            collectionCell.startWokroutTapped.isHidden = true
            collectionCell.deleteButtonTapped.isHidden = true

            
            collectionCell.routineName.text = ""
            collectionCell.ex1.text = ""
            collectionCell.ex2.text = ""
            collectionCell.ex3.text = "No Rountines Added Yet"
            collectionCell.ex4.text = ""
            collectionCell.ex5.text = ""
        }
        return collectionCell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        userRoutine = try! Realm().objects(UserRoutine.self).sorted(byKeyPath: "RoutineName")
        print(userRoutine?[indexPath.row].RoutineName ?? "Null")
    }
    
    
    //MARK: - Delete Routine from Realm DB

    // Present alert to user before delete
    @objc func deleteButtonTappedHandler(_ sender: UIButton)
    {
        let alertController = UIAlertController(title: "Delete this Routine?", message: "All saved exercise on this Routine will be Deleted", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in self.deleteFromRealmDB(_: sender) }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //Delete Routine from Realm DB
    func deleteFromRealmDB(_ sender: UIButton)
    {
        let indexPath = collectionView.indexPath(for: ((sender.superview?.superview) as! StartWorkoutVCCollectionViewCell))
        
        do { try self.realm.write
            {
                realm.delete(userRoutine![indexPath!.row].RoutineExercises) //Deleting Linking Objects first
                realm.delete(userRoutine![indexPath!.row]) // Deleting Rountine Name
            }}
        catch { print("Error Deleting Routine \(error)") }
        collectionView.reloadData()
    }
    
    
    
    
    
    

}
