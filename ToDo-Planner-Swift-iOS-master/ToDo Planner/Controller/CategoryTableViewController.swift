//
//  CategoryTableViewController.swift
//  ToDo Planner
//  Copyright © 2019 Santhosh Umapathi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwiperTableViewController
{
    let realm = try! Realm() //Initializing Realm class
    var categoryArray: Results<Category>? //Results datatype to pull data from Realm

    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none

    }

    //MARK: - TableView DataSource Methods
    
    // Declaring No.of Rows in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) //Inherit from super class swipetableVC
        
        if let category = categoryArray?[indexPath.row]
        {
            cell.textLabel?.text = category.name
            
            cell.backgroundColor = UIColor(hexString: category.color )
            
            //cell.textLabel?.textColor = UIColor(hexString: category.color)
        }
        
        return cell
    }
    
    //MARK: - Model Manipulation Methods
    
    //Create data into database.
    func saveCategories(category: Category)
    {
        do
        {   //Adding new data into realm DB
            try realm.write {
            realm.add(category)
            }
        }
        catch
        {
            print(error)
        }
        tableView.reloadData() //Reloading tableview to reflect new items.
    }
    
    //Read data from database
    func loadCategories()
    {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData() //Reloading tableview to reflect new items.
    }
    
    override func updateModel(at indexpath: IndexPath)
    {
        // Deleting the category after swipe.
        if let categoryDeletion = self.categoryArray?[indexpath.row]
        {
            do
            {
                try self.realm.write
                {
                    self.realm.delete(categoryDeletion)
                }
            }
            catch
            {
                print("Error Deleting category")
            }
        }
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController
        
       if  let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
     
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField() //Creating a local scope variable to reuse.
        
        //Popup with text input
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        //Creating action for the Popup
        let action = UIAlertAction(title: "Add Category", style: .default)
        {
            (action) in
            let newCategory = Category()
            newCategory.name = textField.text! //Setting title property for uitextfield
            newCategory.color = UIColor.randomFlat().hexValue()
            self.saveCategories(category: newCategory)
        }
        
        // Creating text field for alert.
        alert.addTextField
        {  (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action) //Adding action to the alert Popup
        
        present(alert, animated: true, completion: nil) //Presenting alert to UI
    }
}


