//
//  SwiperTableViewController.swift
//  ToDo Planner
//
//  Copyright © 2019 Santhosh Umapathi. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

//Super class for Category class and ToDoList class
class SwiperTableViewController: UITableViewController, SwipeTableViewCellDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell //Prototype cell name, creating reusable cell.
                        
            cell.delegate = self
            return cell
        }
    
    //Swipte action to display delete function
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
    {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
        { action, indexPath in
            
            self.updateModel(at: indexPath)
            
            
            //tableView.reloadData()
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    //Full swipe action to delete
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions
    {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexpath: IndexPath)
    {
        //Updating data model with delete action
    }
    

}

