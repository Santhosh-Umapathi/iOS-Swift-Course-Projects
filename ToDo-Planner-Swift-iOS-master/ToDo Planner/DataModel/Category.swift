//  Category.swift
//  ToDo Planner
//  Copyright © 2019 Santhosh Umapathi. All rights reserved.


import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    let items = List<Item>() //Declaring Child relationship 1 to many
}
