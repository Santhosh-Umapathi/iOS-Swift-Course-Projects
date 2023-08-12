//  WorkoutsVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 1/16/20.
//  Copyright © 2020 App City. All rights reserved.


// Add Button to add exercises to the user
// Upgrade Button Settings
// Upgrade Page Settings




import UIKit
import RealmSwift

class WorkoutsVC: UITableViewController
{
    let realm = try! Realm()
    var workoutsArray: Results<Workouts>!
    
    
    
    @IBOutlet weak var upgradeButton: UIBarButtonItem!
//        {
//        didSet
//        {
//            let imageSetting = UIImageView(image: UIImage(named: "Upgrade"))
//            imageSetting.image = imageSetting.image!.withRenderingMode(.alwaysOriginal)
//            //imageSetting.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            imageSetting.tintColor = UIColor.clear
//            upgradeButton.image = imageSetting.image
//        }
//    }
    
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.register(WorkoutsTableViewCell.self, forCellReuseIdentifier: "WorkoutsTableViewCell")
        tableView.reloadData()
    }

    var workoutNames: [String]
    {
        workoutsArray = realm.objects(Workouts.self)
        let workoutKeys =  Set(workoutsArray.value(forKeyPath: "WorkoutName") as! [String]).sorted()
        return workoutKeys
    }
 
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return workoutNames.count
    }
        
    //CellID
    let workoutscellID = "workoutsCell"

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutsTableViewCell", for: indexPath) as! WorkoutsTableViewCell
        cell.mainImageView.image = UIImage(named: workoutNames[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToWorkoutPlan", sender: self)
    }
    
    
    var userRoutine: Results<UserRoutine>?

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {   //Back Button Settings
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        
        let destinationVC = segue.destination as! WorkoutPlanVC
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.workoutPlanNames = workoutNames[indexPath.row]
           // destinationVC.selectedRoutine = workoutNames[indexPath.row]
        }
    }
    
    //Setting Image height for cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let currentImage = UIImage(named: workoutNames[indexPath.row])
        let imageCrop = currentImage!.getCropRatio()
        return  tableView.frame.width / imageCrop
    }
}


extension UIImage
{   //Get Crop Ratio for Images
    func getCropRatio() -> CGFloat
    {
        let widthRatio = CGFloat(self.size.width/self.size.height)
        return widthRatio
    }
}

