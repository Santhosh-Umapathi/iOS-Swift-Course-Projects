//  WorkoutPlanVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 1/18/20.
//  Copyright © 2020 App City. All rights reserved.

// Upgrade Button Settings
// Upgrade Page Settings


import UIKit
import RealmSwift

class WorkoutPlanVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
    
    @IBOutlet weak var weekImage: UIImageView!
    @IBOutlet weak var addPlanTapped: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    let realm = try! Realm()
    var workoutPlanArray: Results<Workouts>!
    
    override func viewDidLoad()
      {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "WorkoutPlanVCTableViewCell", bundle: nil), forCellReuseIdentifier: weekCellID)
        tableView.reloadData()
        
        addPlanButtonSettings()

    }
    
//    override func viewDidDisappear(_ animated: Bool)
//    { self.navigationController?.popToRootViewController(animated: false) }
    
    //Receive Workout Plan Name from previous Screen
    var workoutPlanNames = ""
    
    //Assign Week Numbers based on plan name
    var weekNumber: [String]
    {
        workoutPlanArray = realm.objects(Workouts.self)
        let weekCount = workoutPlanArray.filter("WorkoutName == %@", workoutPlanNames)
        let weekKeys =  Set(weekCount.value(forKeyPath: "WeekNumber") as! [String]).sorted()
        return weekKeys
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //Navigation Bar title based on plan name
        title = workoutPlanNames
        //navigationItem.leftBarButtonItem?.title = nil
        //tableView.separatorColor = .lightGray
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return weekNumber.count }
    
    //Cell id for Week Numbers
    let weekCellID = "workoutWeekCell"
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: weekCellID, for: indexPath) as! WorkoutPlanVCTableViewCell
        cell.weekLabel.text = weekNumber[indexPath.row]
        
        
        //Setting workout image based on plan
        weekImage.image = UIImage(named: workoutPlanNames)
        
        //addPlanTapped.setTitle("Add Plan to your Routine", for: .normal)
        //addPlanTapped.setTitleColor(.black, for: .normal)
//        addPlanTapped.layer.borderWidth = 0.5
//        addPlanTapped.layer.cornerRadius = 5
//        addPlanTapped.backgroundColor = .clear
//
//        addPlanTapped.layer.borderColor = UIColor.systemYellow.cgColor

        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    { performSegue(withIdentifier: "goToWeekExercises", sender: self) }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {   //Back Button Settings
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        let destinationVC = segue.destination as! ExercisesOverviewVC
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.workoutPlanNames = workoutPlanNames
            destinationVC.weekNumber = weekNumber[indexPath.row]
        }
    }
    
    //var userArray: Results<UserDatabase>!
    let userRoutine = UserRoutine()

    //var selectedRoutine: UserRoutine?
    var userWorkout: Results<UserWorkout>?

    
    var userEmail = UserDefaults.standard.value(forKey: "userEmail") //Getting user email from Login/Signup Screen
    
    var addOns = AddOns()
       
    
    func addPlanToRealmDB(addPlan: UserRoutine)
    {
        do { try realm.write { realm.add(addPlan) }}
        catch { print("Error Updating User \(error)") }
    }
    
    
    func addPlanButtonSettings()
    {
        addPlanTapped.layer.borderWidth = 0.5
        addPlanTapped.layer.cornerRadius = 5
        addPlanTapped.backgroundColor = .clear
        
        addPlanTapped.layer.borderColor = UIColor(hexString: "2F84FF").cgColor //UIColor.systemYellow.cgColor
        
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addPlanToRealmDBHandler))
        addPlanTapped.isUserInteractionEnabled = true
        addPlanTapped.addGestureRecognizer(addTap)
    }
    
    var userRoutineResults: Results<UserRoutine>!

     var routineCheck: [String]
     {
         userRoutineResults = realm.objects(UserRoutine.self)
         let routineCount = userRoutineResults.filter("RoutineName == %@", workoutPlanNames)
         let routineKeys =  Set(routineCount.value(forKeyPath: "RoutineName") as! [String]).sorted()
         return routineKeys
     }
    
    
    @objc func addPlanToRealmDBHandler()
    {
        if routineCheck.contains(workoutPlanNames)
        {
            // Already added Alert
            let alert = UIAlertController(title: "Routine Already Added", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1.5
            DispatchQueue.main.asyncAfter(deadline: when) { alert.dismiss(animated: true, completion: nil) }
        }
        else
        {
            userRoutine.RoutineName = workoutPlanNames
            addPlanToRealmDB(addPlan: userRoutine)
            addPlanExercisesToUserRoutine()
            
            // Success Alert
            let alert = UIAlertController(title: "Routine Added Successfully", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1.5
            DispatchQueue.main.asyncAfter(deadline: when){ alert.dismiss(animated: true, completion: nil) }
            tableView.reloadData()

        }
    }
    
    
 
    func addPlanExercisesToUserRoutine()
    {
        workoutPlanArray = realm.objects(Workouts.self).filter("WorkoutName == %@", workoutPlanNames)
        
        let workoutName = workoutPlanArray.value(forKeyPath: "WorkoutName") as! [String]
        let exerciseName = workoutPlanArray.value(forKeyPath: "ExerciseName") as! [String]
        let weekNumber = workoutPlanArray.value(forKeyPath: "WeekNumber") as! [String]
        let dayNumber = workoutPlanArray.value(forKeyPath: "DayNumber") as! [String]
       // let bodyPartName = workoutPlanArray.value(forKeyPath: "BodyPartName") as! [String]
        //  let categoryName = workoutPlanArray.value(forKeyPath: "CategoryName") as! [String]
        
        
        
        if userRoutine.RoutineName == workoutPlanNames
        {
            do
            {
                try self.realm.write
                {
                    for (en, wn, dn, wkn) in TupleIterator(firstArray: exerciseName, secondArray: weekNumber, thirdArray: dayNumber, fourthArray: workoutName)
                    {
                        let newItem = UserWorkout()
                        newItem.WorkoutName = wkn
                        newItem.ExerciseName = en
                        newItem.WeekNumber = wn
                        newItem.DayNumber = dn
                        userRoutine.RoutineExercises.append(newItem)
                    }
                }
            } catch { print("Error saving new items, \(error)") }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
}
