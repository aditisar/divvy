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
    
    var groupCode: String
    var members: [User]
    var parseId: String?;
    var open = true
    
    init() {
        groupCode = Meal.generateGroupCode()
        members = [User]()
    }
    
    static func generateGroupCode() -> String {
        return String(Int(arc4random_uniform(9000)) + 1000)
    }
    
    func convertToPFObject() -> PFObject {
        let parseMeal = PFObject(className: "Meal")
        parseMeal["groupCode"] = self.groupCode
        parseMeal["open"] = self.open
        //if meal has been saved before
        if let id = self.parseId {
            parseMeal["objectId"] = id
        }
        return parseMeal
    }
    
    func saveToParse() {
        let parseMeal = self.convertToPFObject()
        parseMeal.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Meal", "has been saved with id", parseMeal.objectId! )
            self.parseId = parseMeal.objectId!
            Meal.curMeal = self;
        }
    }
    
}