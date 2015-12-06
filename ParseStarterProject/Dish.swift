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
    var parseObject: PFObject?
    
    init(name: String, cost: Double) {
        self.name = name
        self.cost = cost
        
    }
    
    func convertToPFObject() -> PFObject {
        let parseDish = PFObject(className: "Dish")
        parseDish["name"] = self.name
        parseDish["cost"] = self.cost
        //if meal has been saved before
        if let id = self.parseId {
            parseDish["objectId"] = id
        }
        return parseDish
    }
    
    func saveToParse() {
        let parseDish = self.convertToPFObject()
        parseDish.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Dish has been saved with id", parseDish.objectId! )
            self.parseId = parseDish.objectId!
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