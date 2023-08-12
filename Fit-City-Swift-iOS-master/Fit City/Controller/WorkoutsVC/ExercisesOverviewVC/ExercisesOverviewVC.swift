//  ExercisesOverviewVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 1/21/20.
//  Copyright © 2020 App City. All rights reserved.


// Upgrade Button Settings
// Upgrade Page Settings






import UIKit
import RealmSwift

class ExercisesOverviewVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    let realm = try! Realm()
    var exercisesOverviewArray: Results<Workouts>!
    
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPlanTapped: UIButton!
    
    
    
    var workoutPlanNames = "" //Receive Workout Plan Name from previous Screen
    var weekNumber = ""       //Receive Week Number from previous Screen

    
    override func viewWillAppear(_ animated: Bool)
    {
        title = weekNumber //Navigation Bar title based on plan name
        //tableView.separatorColor = .lightGray
    }
    
    override func viewDidLoad()
    {
        tableView.dataSource = self
        tableView.delegate = self
        
        //Register Custom Cell
        tableView.register(UINib(nibName: "ExerciseOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        
        //Reload TableView to adjust IndexTitles and load all data.
        tableView.reloadData()
        addPlanButtonSettings()
    }
    
    
    
    
    var exercisesOverview: [String]
    {
        exercisesOverviewArray = realm.objects(Workouts.self).filter("WorkoutName == %@ AND WeekNumber == %@", workoutPlanNames, weekNumber)
        let exerciseKeys =  Set(exercisesOverviewArray.value(forKeyPath: "DayNumber") as! [String]).sorted()
        return exerciseKeys
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)//(name: "Arial-Italic", size: 20)
     }
    
    func numberOfSections(in tableView: UITableView) -> Int
    { exercisesOverview.count }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    { return exercisesOverview[section] }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    { return exercisesOverview }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return exercisesOverviewArray.filter("DayNumber == %@", exercisesOverview[section]).count
    }
    
    //Custom Cell ID
    let cellID = "exerciseOverviewCell"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ExerciseOverviewTableViewCell
        
        exercisesOverviewArray = realm.objects(Workouts.self).filter("WorkoutName == %@ AND WeekNumber == %@", workoutPlanNames, weekNumber)
        
        if let exerciseList = exercisesOverviewArray?.filter("DayNumber == %@", exercisesOverview[indexPath.section])[indexPath.row]
        {
            cell.exerciseName.text = exerciseList.ExerciseName
            cell.bodyPartName.text = "(\(exerciseList.BodyPartName))"
            cell.categoryName.text = exerciseList.CategoryName ?? ""
            cell.exerciseImage.image = UIImage(named: "\(exerciseList.ExerciseName) \(exerciseList.CategoryName ?? "")")
            
            
//            addPlanTapped.layer.borderWidth = 0.5
//            addPlanTapped.layer.cornerRadius = 5
//            addPlanTapped.backgroundColor = .clear
//
//            addPlanTapped.layer.borderColor = UIColor.systemYellow.cgColor
        }
        return cell
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
        
        addPlanTapped.layer.borderColor = UIColor(hexString: "2F84FF").cgColor//UIColor.systemYellow.cgColor
        
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
            DispatchQueue.main.asyncAfter(deadline: when)
            { alert.dismiss(animated: true, completion: nil) }
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
        }
    }
    
    
    
    func addPlanExercisesToUserRoutine()
    {
        exercisesOverviewArray = realm.objects(Workouts.self).filter("WorkoutName == %@", workoutPlanNames)
        
         let workoutName = exercisesOverviewArray.value(forKeyPath: "WorkoutName") as! [String]
        let exerciseName = exercisesOverviewArray.value(forKeyPath: "ExerciseName") as! [String]
        let weekNumber = exercisesOverviewArray.value(forKeyPath: "WeekNumber") as! [String]
        let dayNumber = exercisesOverviewArray.value(forKeyPath: "DayNumber") as! [String]
        // let bodyPartName = workoutPlanArray.value(forKeyPath: "BodyPartName") as! [String]
        //  let categoryName = workoutPlanArray.value(forKeyPath: "CategoryName") as! [String]
        
        
        
        if userRoutine.RoutineName == workoutPlanNames
        {
            do { try self.realm.write
                {
                    for (en, wn, dn, wkn) in TupleIterator(firstArray: exerciseName, secondArray: weekNumber, thirdArray: dayNumber, fourthArray: workoutName)
                    {
                        let newItem = UserWorkout()
                        newItem.WorkoutName = wkn
                        newItem.ExerciseName = en
                        newItem.WeekNumber = wn
                        newItem.DayNumber = dn
                        userRoutine.RoutineExercises.append(newItem)
                    }}} catch { print("Error saving new items, \(error)") }
        }}
    
    
    
    
    
    
    
    
    
    
    
}
