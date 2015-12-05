//
//  UserWillJoinViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import UIKit

class UserWillJoinViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.keyboardType = UIKeyboardType.NumberPad
    }
    
    
    @IBAction func codeEntered(sender: AnyObject) {
        let code = Int(codeTextField!.text!)!
        
        //see if there is a meal with the same groupcode
        let query = PFQuery(className: "Meal")
        query.whereKey("groupCode", equalTo: String(code))
        query.findObjectsInBackgroundWithBlock {
            (meals: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(meals!.count) meals.")
                // Do something with the found objects
                if let meals = meals {
                    //                    for meal in meals {
                    //                        print(meal.objectId)
                    //                    }
                    if (meals.count != 1) {//if there's more than one meal with this code
                        print("More than one meal with this code")
                        //TODO ensure this doesn't happen
                    } else {
                        let meal = meals[0]
                        User.curUser?.meal = meal
                        User.curUser?.updateParseObject("parent", val: meal)
                        self.performSegueWithIdentifier("userJoinedParty", sender: self)
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
        
    }
    
    
}