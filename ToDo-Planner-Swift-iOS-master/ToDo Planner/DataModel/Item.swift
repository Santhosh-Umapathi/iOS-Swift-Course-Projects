//  Item.swift
//  ToDo Planner
//  Copyright © 2019 Santhosh Umapathi. All rights reserved.

import Foundation
import RealmSwift

class Item: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var color: String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //Declaring inverse relationship to parent category.
}

