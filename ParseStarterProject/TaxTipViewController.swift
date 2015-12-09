//
//  TaxTipViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class TaxTipViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var groupTotal: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipSliderLabel: UILabel!
    @IBOutlet weak var taxTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTotal()
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
    
    
    @IBAction func tipSliderChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        tipSliderLabel.text = "\(currentValue) %"
    }
    
    @IBAction func calculateAmountsPressed(sender: AnyObject) {
        if taxTextField.text == "" {
            taxTextField.becomeFirstResponder()
        } else {
            Meal.curMeal?.tax = Double(taxTextField.text!)!
            Meal.curMeal?.tip = Double(tipSlider.value * 0.01)
            Meal.curMeal?.updateParseObject("tax", val: taxTextField.text!)
            Meal.curMeal?.updateParseObject("tip", val: tipSlider.value * 0.01)
            performSegueWithIdentifier("divvy", sender: self)
        }
    
    }
    
}