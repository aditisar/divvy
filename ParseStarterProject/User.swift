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
    //stages of where the user is in the process
    static let UserJoining = 0 , UserJoined = 1, UserDishesSaved = 2, UserSharedDishesRemoved = 3
    
    var username: String
    var isLeader: Bool
    var stage = 0;
    var payment = 0.0;
    var parseId: String?
    var meal: PFObject?
    var dishes: [Dish]
    
    
    init(username: String) {
        
        self.username = username
        self.isLeader = false
        self.stage = User.UserJoining
        self.payment = 0.0
        
        dishes = [Dish]()

        
    }
    
    //returns a PFObject version of a User
    func convertToPFObject() -> PFObject {
        let parseUser = PFObject(className: "User")
        parseUser["username"] = self.username
        parseUser["isLeader"] = self.isLeader
        parseUser["stage"] = self.stage
        parseUser["payment"] = self.payment
        
        //if there's a meal associated with it already
        if let meal = self.meal {
            parseUser["parent"] = meal
        }
        //if it has been saved before
        if let id = self.parseId {
            print("heyo")
            parseUser["objectId"] = id
        }
        return parseUser
    }
    
    func saveToParse() {
        let parseUser = self.convertToPFObject()
        parseUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("User", self.username, "has been saved with id", parseUser.objectId! )
            self.parseId = parseUser.objectId!
            User.curUser = self;
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