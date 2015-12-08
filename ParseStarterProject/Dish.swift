//
//  Dish.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class Dish {
    
    var name: String
    var cost: Double
    var parseId: String?;
    var parseObject: PFObject
    var mealParseObject: PFObject
    var users: [PFObject]
    
    init(name: String, cost: Double, meal: PFObject) {
        //initialize local variables
        self.name = name
        self.cost = cost
        self.users = [PFObject]()
        self.mealParseObject = meal
        
        //create a Parse version
        let parseDish = PFObject(className: "Dish")
        parseDish["name"] = self.name
        parseDish["cost"] = self.cost
        let relation = parseDish.relationForKey("users")
        for user in users {
            relation.addObject(user)
        }
        parseDish["meal"] = self.mealParseObject
        self.parseObject = parseDish
    }

    //updates parse object with local properties, should only be called after dish has been saved once
    func updateDishParseObjectFromLocal(){
        let query = PFQuery(className:"Dish")
        query.getObjectInBackgroundWithId(self.parseId!) {
            (parseDish: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                print("no such dish with that id")
            } else if let parseDish = parseDish {
                parseDish["name"] = self.name
                parseDish["cost"] = self.cost
                let relation = parseDish.relationForKey("users")
                for user in self.users {
                    relation.addObject(user)
                    print(user["username"])
                }
//                parseDish["meal"] = self.mealParseObject
                self.parseObject = parseDish
                parseDish.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    print("Dish has been updated to match local version.")
                }
            }
        }
    }
    
    //update the parse object with key val pair, need id for this method
    func updateParseObject(key: String, val: AnyObject) {
        let query = PFQuery(className:"Dish")
        query.getObjectInBackgroundWithId(self.parseId!) {
            (parseDish: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let parseDish = parseDish {
                parseDish[key] = val
                parseDish.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    print("Dish has been updated with", key,":", val)
                }
            }
        }
    }
    
    
    //saves to parse after updating its users relation
    func saveToParse() {
        let relation = self.parseObject.relationForKey("users")
        for user in users {
            relation.addObject(user)
        }
        self.parseObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Dish has been saved with id", self.parseObject.objectId! )
            self.parseId = self.parseObject.objectId!
        }
    }
    
}