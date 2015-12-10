//
//  TaxTipViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

@available(iOS 8.0, *)
class TaxTipViewController: UIViewController, UITextFieldDelegate {
    
    var checkIfAllDishesEntered: NSTimer?
    
    @IBOutlet weak var groupTotal: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipSliderLabel: UILabel!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var divvyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTotal()
        divvyButton.enabled = false
        checkIfAllDishesEntered = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkIfAllUsersReady"), userInfo: nil, repeats: true)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    func getTotal(){
        print("in get total")
        Meal.curMeal!.groupTotal = 0
        let query = PFQuery(className:"Dish")
        query.whereKey("meal", equalTo: (Meal.curMeal?.parseObject)!) //get all dishes with this meal
        query.findObjectsInBackgroundWithBlock { (mealDishes: [PFObject]?, error: NSError?) -> Void in
            for dish in mealDishes! {
                Meal.curMeal!.groupTotal+=dish["cost"] as! Double
            }
            self.groupTotal.text = String(format: "Group Total: $%.2f", Meal.curMeal!.groupTotal)
            Meal.curMeal?.parseObject["groupTotal"] = Meal.curMeal!.groupTotal
            Meal.curMeal?.parseObject.saveInBackground()
        }
    }
    
    func checkIfAllUsersReady(){
        print("checking if all users are ready")
        var numUsersFinished = 0
        let query = PFQuery(className:"User")
        query.whereKey("parent", equalTo: (Meal.curMeal?.parseObject)!) //get all users in the meal
        query.findObjectsInBackgroundWithBlock { (mealUsers: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                for user in mealUsers! {
                    print("checking if user", user["username"], "is finished entering their dishes")
                        if user["isFinishedEnteringDishes"] as! Bool == true {
                            print("user", user["username"], " did finish")
                            numUsersFinished += 1
                        }
                }
            }
            print("local numUsers", Meal.curMeal!.numUsers)
            print("cloud numUsers finished", numUsersFinished)

            if numUsersFinished == Meal.curMeal!.numUsers {
                self.divvyButton.enabled = true
            }
        }

    }
    
    @IBAction func tipSliderChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        tipSliderLabel.text = "\(currentValue) %"
    }
    
    @IBAction func calculateAmountsPressed(sender: AnyObject) {
        
        
        if taxTextField.text == "" {
            taxTextField.becomeFirstResponder()
        } else {
            
            if let tax = Double(taxTextField.text!) {
                Meal.curMeal?.tax = Double(taxTextField.text!)!
                Meal.curMeal?.tip = Double(tipSlider.value * 0.01)
                Meal.curMeal?.updateParseObject("tax", val: taxTextField.text!)
                Meal.curMeal?.updateParseObject("tip", val: tipSlider.value * 0.01)
                checkIfAllDishesEntered!.invalidate()
                performSegueWithIdentifier("divvy", sender: self)
            
            } else {
                let alertController = UIAlertController(title: "Invalid tax", message: "Tax should be a number.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    self.taxTextField.selectAll(self)
                }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true){}
            }

        }
    
    }
    
}