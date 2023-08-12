//
//  ViewController.swift
//  ToDo Planner
////  Copyright © 2019 Santhosh Umapathi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
                              //Inherit SwipteTableView Controller
class ToDoListViewController: SwiperTableViewController
{
    let realm = try! Realm()
    var itemArray: Results<Item>?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? //Creating optional because can be empty at beginning
    {
        didSet //Only Loading values immediately after created.
        {
            loadItems()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //loadItems() // Loading all the data at beginning with default value
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        title = selectedCategory?.name // Setting title of the category name
        searchBar.barTintColor = UIColor(hexString: selectedCategory?.color)
        //navigationController?.navigationBar.barTintColor = UIColor(hexString: selectedCategory?.color) // Bar color
        navigationController?.navigationBar.tintColor = UIColor(hexString: selectedCategory?.color) //Button colors
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(hexString: selectedCategory?.color)]
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        navigationController?.navigationBar.tintColor = UIColor(hexString: "1D9BF6") //Button colors
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "1D9BF6")]
    }
    
    
    
    //MARK: - TableView DataSource Methods
    
    // Declaring No.of Rows in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row]
        {
            cell.textLabel?.text = item.title // Setting arrays row and text for cell //Tap into title property
            
            let colorbg = UIColor(hexString: item.color).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count))
            
            cell.backgroundColor = colorbg
            //cell.textLabel?.textColor = ContrastColorOf(backgroundColor: cell.backgroundColor!, returnFlat: false)

            //Ternary Operator:
            //Value = Condition ? ValueIfTrue : ValueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none //Replacing if else condition(58)
            //cell.textLabel?.textColor = UIColor.flatGray()
        }
        else
        {
            cell.textLabel?.text = "No Items Added"
        }
//        cell.textLabel?.textColor = UIColor.flatRed()
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let item = itemArray?[indexPath.row]
        {
            do
            {
                try realm.write //Update DB
                {
                    item.done = !item.done //To set checkmark
                    //realm.delete(item) //To Delete data
                }
            }
            catch
            {
                print("Error updating checkmarks")
            }
        }
        tableView.reloadData()
    }
    
//MARK: - Adding Items to Cell
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField() //Creating a local scope variable to reuse.
        
        //Popup with text input
        let alert = UIAlertController(title: "Add new To Do Item", message: "", preferredStyle: .alert)
        
        //Creating action for the Popup
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in
            //print("Success!")  //print(textField.text)
            if let currentCategory = self.selectedCategory
            {
                do
                {
                    try self.realm.write
                    {
                        let newItem = Item()
                        newItem.title = textField.text! //Setting title property for uitextfield
                        newItem.dateCreated = Date()
                        newItem.color = self.selectedCategory!.color
                        
//                        self.navigationController?.navigationBar.tintColor = UIColor(named: newItem.color)

                        currentCategory.items.append(newItem)
                    }
                }
                catch
                {
                   print("Error saving new items")
                }
            }
            self.tableView.reloadData()
        }
        
        // Creating text field for alert.
        alert.addTextField
        {   (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action) //Adding action to the alert Popup
        
        present(alert, animated: true, completion: nil) //Presenting alert to UI
    }
    
//MARK: - Model Manipulation Methods
        
    //Read data from database
    func loadItems()
    {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData() //Reloading tableview to reflect new items.
    }
    
    override func updateModel(at indexpath: IndexPath)
    {
        // Deleting the category after swipe.
        if let itemDeletion = self.itemArray?[indexpath.row]
        {
            do
            {
                try self.realm.write
                {
                    self.realm.delete(itemDeletion)
                }
            }
            catch
            {
                print("Error Deleting items")
            }
        }
    }
}
//MARK: - Search Functionality
    
                                    //Set Delegate for search bar
extension ToDoListViewController: UISearchBarDelegate
{
    //Search button pressed function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
        //Loading all data when search field cleared.
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
        {
            if searchBar.text?.count == 0
            {
                loadItems()
                DispatchQueue.main.async //Since needs to run this process in main thread
                {
                    searchBar.resignFirstResponder() //Disable searchbar and keyboard.
                }
            }
        }
}

