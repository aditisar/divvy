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

@available(iOS 8.0, *)
class UserWillJoinViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.keyboardType = UIKeyboardType.NumberPad
        codeTextField.becomeFirstResponder()
    }
    
    
    @IBAction func codeEntered(sender: AnyObject) {
        
        if codeTextField.text!.characters.count > 0 {
            
            if let code = Int(codeTextField!.text!) { //if it is an integer
                
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
                            if (meals.count == 0){
                                print("No meal with this code..")
                                let alertController = UIAlertController(title: "Invalid code", message: "No open groups with that code exist.", preferredStyle: .Alert)
                                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                                    self.codeTextField.text = ""
                                    self.codeTextField.becomeFirstResponder()
                                }
                                alertController.addAction(cancelAction)
                                self.presentViewController(alertController, animated: true){}

                                //TODO alert user
                            } else if (meals.count != 1) {//if there's more than one meal with this code
                                print("More than one meal with this code")
                                //TODO ensure this doesn't happen
                            } else {
                                let parseMeal = meals[0]
                                //create a local meal object with the correct code
                                let meal = Meal(groupCode: parseMeal["groupCode"] as! String)
                                meal.parseId = parseMeal.objectId
                                meal.parseObject = parseMeal
                                Meal.curMeal = meal
                                User.curUser?.meal = parseMeal
                                User.curUser?.updateParseObject("parent", val: parseMeal)
                                self.performSegueWithIdentifier("userJoinedParty", sender: self)
                                //print(Meal.curMeal!.getUsernames())
                            }
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Invalid code", message: "Group code should be a 4 digit number.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    self.codeTextField.text = ""
                    self.codeTextField.becomeFirstResponder()
                }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true){}
            }
        } else { //if no text was entered
            codeTextField.becomeFirstResponder()
        }
        
    }
    
    
}