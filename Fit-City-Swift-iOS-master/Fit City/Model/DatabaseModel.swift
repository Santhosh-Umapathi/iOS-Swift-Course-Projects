//  Realm Model.swift
//  Fit City
//  Created by Santhosh Umapathi on 11/23/19.
//  Copyright © 2019 App City. All rights reserved.

import UIKit
import RealmSwift


//MARK: - Exercises

class Exercises: Object
{

    @objc dynamic var ExerciseID = 0
    @objc dynamic var ExerciseName = ""
    @objc dynamic var BodyPartName = ""
    @objc dynamic var CategoryName: String? = ""
    
}

class Workouts: Object
{
    @objc dynamic var WorkoutID = ""
    @objc dynamic var WorkoutName = ""
    @objc dynamic var TotalWeeks = 0
    @objc dynamic var WeekNumber = ""
    @objc dynamic var DayNumber = ""
    @objc dynamic var ExerciseName = ""
    @objc dynamic var BodyPartName = ""
    @objc dynamic var CategoryName: String? = ""
    
   // var parentRoutine = LinkingObjects(fromType: UserRoutine.self, property: "RoutineExercises")

}

class UserDatabase: Object
{
    @objc dynamic var FirstName = ""
    @objc dynamic var LastName = ""
    @objc dynamic var Gender = ""
    @objc dynamic var DateOfBirth = ""
    @objc dynamic var Height = 155
    @objc dynamic var Weight = 40
    @objc dynamic var Email = ""
    @objc dynamic var Password = ""
    @objc dynamic var ProfileImage = Data()
    @objc dynamic var BMI = 18.0
    @objc dynamic var FitnessGoal = "--"
    @objc dynamic var Calories = 1200

    

}



class UserRoutine: Object
{
//    @objc dynamic var WorkoutName = ""
//    @objc dynamic var WeekNumber = ""
//    @objc dynamic var DayNumber = ""
//    @objc dynamic var ExerciseName = ""
//    @objc dynamic var BodyPartName = ""
//    @objc dynamic var CategoryName: String? = ""

    @objc dynamic var RoutineName = ""
//
    let RoutineExercises = List<UserWorkout>()

    
}

class UserWorkout: Object
{
    @objc dynamic var WorkoutName = ""
    @objc dynamic var ExerciseName = ""
    @objc dynamic var WeekNumber = ""
    @objc dynamic var DayNumber = ""
    @objc dynamic var Weight = 0
    @objc dynamic var Sets = 0
    @objc dynamic var Reps = 0
    
     var parentRoutine = LinkingObjects(fromType: UserRoutine.self, property: "RoutineExercises")

}




