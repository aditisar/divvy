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
    var users: [User]
    
    init(name: String, cost: Double, meal: PFObject) {
        //initialize local variables
        self.name = name
        self.cost = cost
        self.users = [User]()
        self.users.append(User.curUser!)
        self.mealParseObject = meal
        
        //create a Parse version
        let parseDish = PFObject(className: "Dish")
        parseDish["name"] = self.name
        parseDish["cost"] = self.cost
        let relation = parseDish.relationForKey("users")
        for user in users {
            relation.addObject(user.parseObject!)
        }
        parseDish["meal"] = self.mealParseObject
        self.parseObject = parseDish
        self.saveToParse()
    }

    //saves to parse, is only used to be called in init
    
    
    //updates parse object with local properties, should only be called after dish has been saved once
    func updateDishParseObjectFromLocal(){
        if let a = self.parseId {
            print("aint erroring on this either")
        }
        sleep(15)

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
                    relation.addObject(user.parseObject!)
                }
                parseDish["meal"] = self.mealParseObject
                self.parseObject = parseDish
                parseDish.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    print("Dish has been updated to match local version.")
                }
            }
        }
    }
    
    func updateDishLocalObjectFromParse(){

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
    
    private
    
    func saveToParse() {
        self.parseObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Dish has been saved with id", self.parseObject.objectId! )
            self.parseId = self.parseObject.objectId!
        }
    }
    
    //maybe a get Users? and a get Meal
//    func getUsernames() -> [String]{
//        var usernames = [String]()
//        let query = PFQuery(className: "User")
//        query.whereKey("parent", equalTo: (parseObject)!)
//        query.findObjectsInBackgroundWithBlock {
//            (users: [PFObject]?, error: NSError?) -> Void in
//            for user in users! {
//                print("got a user", user.objectId)
//                print("got a user", user["username"])
//                usernames.append(user["username"] as! String)
//            }
//            
//        }
//        print("out of for", usernames)
//        return usernames
//    }
    
}