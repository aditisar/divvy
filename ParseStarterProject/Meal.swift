//
//  Party.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class Meal {
    
    static var curMeal: Meal?
    //stages of where the meal is in the process
    static let MealCreated = 0 , BeginAddingDishes = 1
 
    var groupCode: String
    var members: [User]
    var dishes: [Dish]
    var parseId: String?;
    var parseObject: PFObject
    var open = true
    var stage = 0
    
    init(groupCode: String) {
        //initialize local variables
        self.groupCode = groupCode
        members = [User]()
        dishes = [Dish]()
        
        //create a parse version
        let parseMeal = PFObject(className: "Meal")
        parseMeal["groupCode"] = self.groupCode
        self.parseObject = parseMeal
        self.saveToParse()

    }
    
    static func generateGroupCode() -> String {
        return String(Int(arc4random_uniform(9000)) + 1000)
    }
//    
//    func convertToPFObject() -> PFObject {
//        let parseMeal = PFObject(className: "Meal")
//        parseMeal["groupCode"] = self.groupCode
//        parseMeal["open"] = self.open
//        //if meal has been saved before
//        if let id = self.parseId {
//            parseMeal["objectId"] = id
//        }
//        return parseMeal
//    }
    
//    func saveToParse() {
//        let parseMeal = self.convertToPFObject()
//        parseMeal.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("Meal", "has been saved with id", parseMeal.objectId! )
//            self.parseId = parseMeal.objectId!
//            Meal.curMeal = self;
//        }
//    }
    
    //update the parse object with key val pair, need id to be previously stored for this method
    func updateParseObject(key: String, val: AnyObject) {
        let query = PFQuery(className:"Meal")
        query.getObjectInBackgroundWithId(self.parseId!) {
            (parseMeal: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let parseMeal = parseMeal {
                parseMeal[key] = val
                parseMeal.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    print("Meal has been updated with", key,":", val)
                }
            }
        }
    }

    func getUsernames() -> [String]{
        var usernames = [String]()
        let query = PFQuery(className: "User")
        query.whereKey("parent", equalTo: (parseObject))
        query.findObjectsInBackgroundWithBlock {
            (users: [PFObject]?, error: NSError?) -> Void in
            for user in users! {
                print("got a user", user.objectId)
                print("got a user", user["username"])
                usernames.append(user["username"] as! String)
            }
            
        }
        print("out of for", usernames)
        return usernames
    }
    
    private
    
    func saveToParse() {
        self.parseObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Meal", "has been saved with id", self.parseObject.objectId! )
            self.parseId = self.parseObject.objectId!
            Meal.curMeal = self;
        }
    }
    
    
}