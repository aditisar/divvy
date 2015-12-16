//
//  User.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse


class User {
    
    static var curUser: User?
    static var allUsers = [PFObject]()

    var username: String
    var isLeader: Bool
    var payment = 0.0;
    var parseId: String?
    var parseObject: PFObject?
    var meal: PFObject?
    var dishes: [Dish]
    var isFinishedEnteringDishes = false
    
    init(username: String) {
        
        self.username = username
        self.isLeader = false
        self.payment = 0.0
        
        dishes = [Dish]()
        
    }
    
    //returns a PFObject version of a User
    func convertToPFObject() -> PFObject {
        let parseUser = PFObject(className: "User")
        parseUser["username"] = self.username
        parseUser["isLeader"] = self.isLeader
        parseUser["payment"] = self.payment
        parseUser["isFinishedEnteringDishes"] = self.isFinishedEnteringDishes
        
        //if there's a meal associated with it already
        if let meal = self.meal {
            parseUser["parent"] = meal
        }
        return parseUser
    }
    
    func saveToParse() {
        let parseUser = self.convertToPFObject()
        let acl = PFACL()
        acl.publicWriteAccess = true
        acl.publicReadAccess = true
        parseUser.ACL = acl
        parseUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("User", self.username, "has been saved with id", parseUser.objectId! )
            self.parseId = parseUser.objectId!
            self.parseObject = parseUser
            User.curUser = self;
            if let meal = parseUser["parent"] {
                Meal.curMeal?.parseObject = meal as! PFObject
            }
        }
    }
    
    //update the parse object with key val pair, need id for this method
    func updateParseObject(key: String, val: AnyObject) {
        let query = PFQuery(className:"User")
        query.getObjectInBackgroundWithId(self.parseId!) {
            (parseUser: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let parseUser = parseUser {
                parseUser[key] = val
                parseUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    print("User", self.username, "has been updated with", key,":", val)
                }
            }
        }
    }
    
    
    
    
}