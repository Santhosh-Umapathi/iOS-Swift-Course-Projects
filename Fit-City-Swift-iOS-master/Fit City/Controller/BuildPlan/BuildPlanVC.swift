//  BuildPlanVC.swift
//  Fit City
//  Created by Santhosh Umapathi on 11/23/19.
//  Copyright © 2019 App City. All rights reserved.
//https://stackoverflow.com/questions/48421417/how-to-change-uinavigationbar-background-color-from-clear-to-red-when-user-scrol


// Add Button to add Routine to the user
// Add button to add exercises to user





import UIKit
import RealmSwift
import SwipeCellKit

class BuildPlanVC: UITableViewController, SwipeTableViewCellDelegate
{
    let realm = try! Realm()
    var exerciseArray: Results<Exercises>!
    let searchController = UISearchController()
    
    
    //Segue for Exit from AddNewExerciseVC & Reload BuildPlanVC
    @IBAction func exitToBuildPlanVC(segue: UIStoryboardSegue)
    {
        DispatchQueue.global(qos: .userInitiated).async
        { DispatchQueue.main.async { self.tableView.reloadData() } }
    }
    
    
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchBarSettings()
                
        tableView.register(UINib(nibName: "customCell", bundle: nil), forCellReuseIdentifier: cellID) //Register Custom Cell
        tableView.reloadData() //Reload Tableview Data
    }
    
    //MARK: - TableView DataSource Methods
    
    //Assigning BodyPartName as Section Names
    var sectionNames: [String]
    {
        exerciseArray = try! Realm().objects(Exercises.self).sorted(by: ["ExerciseName"])
        let sectionKeys =  Set(exerciseArray.value(forKeyPath: "BodyPartName") as! [String]).sorted()
        return sectionKeys
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        //header.tintColor = .white
        //header.textLabel?.textColor = UIColor.systemBlue
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)//(name: "Arial-Italic", size: 20)
     }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        let searchText = searchController.searchBar.text!

        if (searchText.count > 0) { return 1 } //(exerciseArray?.filter("ExerciseName CONTAINS[cd] %@", searchController.searchBar.text!).count)!
        else { return sectionNames.count }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let searchText = searchController.searchBar.text!

        if (searchText.count > 0) { return "" }//exerciseArray?.filter("BodyPartName CONTAINS[cd] %@", searchController.searchBar.text!)
        else { return sectionNames[section] }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        let searchText = searchController.searchBar.text!

        if (searchText.count > 0) { return nil }
        else { return sectionNames }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let searchText = searchController.searchBar.text!
        
        if (searchText.count > 0)
        {
            // Return Filtered Data Source count
            return (exerciseArray?.filter("ExerciseName CONTAINS[cd] %@", searchText).count)!
        }
        else
        {
            // Return Normal Data Source count
            return exerciseArray.filter("BodyPartName == %@", sectionNames[section]).count
        }
    }
    
    // Register custom cell for Table View
    let cellID = "customCell1"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! customCell
        cell.delegate = self
        
        let searchText = searchController.searchBar.text!

        exerciseArray = realm.objects(Exercises.self).sorted(byKeyPath: "ExerciseName")
        
        if (searchText.count > 0)
        {
            // Bind Data to the Search Data Source
            if let exerciseList = exerciseArray?.filter("ExerciseName CONTAINS[cd] %@", searchText)[indexPath.row]
            {
                cell.exerciseName.text = exerciseList.ExerciseName
                cell.categoryName.text = exerciseList.CategoryName ?? ""
                cell.exerciseImage.image = UIImage(named: "\(exerciseList.ExerciseName) \(exerciseList.CategoryName ?? "")")
            }
        }
        else
        {
            // Bind Data to the Normal Data Source
            if let exerciseList = exerciseArray?.filter("BodyPartName == %@", sectionNames[indexPath.section])[indexPath.row]
            {
                cell.exerciseName.text = exerciseList.ExerciseName
                cell.categoryName.text = exerciseList.CategoryName ?? ""
                cell.exerciseImage.image = UIImage(named: "\(exerciseList.ExerciseName) \(exerciseList.CategoryName ?? "")")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
    {
        guard orientation == .left else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
        { action, indexPath in
            //Handle action by updating model with deletion
            do
            {
                try self.realm.write
                {
                    self.realm.delete(self.exerciseArray.filter("BodyPartName == %@", self.sectionNames[indexPath.section])[indexPath.row])
                }
            }
            catch { print("Error Deleting Exercise \(error)") }
            tableView.reloadData()
        }
        // Customize the action appearance
        deleteAction.image = UIImage(named: "Delete Icon")
        return [deleteAction]
    }
    
    

    
    //MARK: - TableView Delegate Methods
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let searchText = searchController.searchBar.text!

        if (searchText.count > 0)
        {
           let exerciseName = exerciseArray.filter("ExerciseName CONTAINS[cd] %@", searchText)[indexPath.row].ExerciseName
            print(exerciseName)
            
            self.performSegue(withIdentifier: "goToAddRoutine", sender: self)

            
            //Displaying the Popup View for Routine
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now())
//            {
//                let pop = RoutinePopup()
//                self.view.addSubview(pop)
//            }
            
            //tableView.isScrollEnabled = false

//            tableView.reloadData()

        }
        else
        {
            let exerciseName = exerciseArray.filter("BodyPartName == %@", sectionNames[indexPath.section])[indexPath.row].ExerciseName
            print(exerciseName)
            

            
            self.performSegue(withIdentifier: "goToAddRoutine", sender: self)
            
            
            
            
        }
    }


    
    
    func save(newExercise: Exercises)
    {
        do { try realm.write { realm.add(newExercise) } }
        catch { print("Error Saving New Exercise \(error)") }
        tableView.reloadData()
    }
    
    
//    func addExerciseButtonTapped()
//    {
//
//
//        self.performSegue(withIdentifier: "goToAddNewExercise", sender: self)
//
//    }
    
  
    
    
    
  
}


extension BuildPlanVC: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate
{
       //Search Bar Settings
       func searchBarSettings()
       {
        //Delegates
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        //Settings
        searchController.searchBar.placeholder = "Search Exercise"
        searchController.searchBar.setMagnifyingGlassColorTo(color: .white) // Search bar lens color
        searchController.searchBar.searchTextField.tintColor = .white // Search bar blinker color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Search Bar Place Holder text color
        
        //searchController.searchBar.searchTextField.textColor = .white

//        searchController.searchBar.setPlaceholderTextColorTo(color: .blue)
//        searchController.searchBar.setClearButtonColorTo(color: .white)
        //UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        searchController.searchBar.autocapitalizationType = .words
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.sizeToFit()
       }
       
       func updateSearchResults(for searchController: UISearchController)
       {
        let searchText = searchController.searchBar.text!
                
        //Real-time live results
        DispatchQueue.main.async(execute:
        {
            if searchText.count > 0
            {
                //Filtered Data Source for TableView
                self.exerciseArray = self.exerciseArray?.filter("ExerciseName CONTAINS[cd] %@", searchText)
                self.tableView.reloadData()//Your tableView here
            }
            else
            {
                //Normal Data Source for TableView
                self.exerciseArray = self.realm.objects(Exercises.self).sorted(byKeyPath: "ExerciseName")
                self.tableView.reloadData()
            }
        })
       }
}


