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
    @IBOutlet weak var roundUpSwitch: UISwitch!
    @IBOutlet weak var taxTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        let total = 30.00 //change to actual total
        groupTotal.text = "Group Total: $0.00" // + \(total)"
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }


    @IBAction func tipSliderChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        tipSliderLabel.text = "\(currentValue) %"
    }
    
    @IBAction func calculateAmountsPressed(sender: AnyObject) {
        Meal.curMeal?.updateParseObject("tax", val: taxTextField.text! )
        Meal.curMeal?.updateParseObject("tip", val: tipSlider.value * 0.01)
        Meal.curMeal?.updateParseObject("roundUp", val: roundUpSwitch.on)
        performSegueWithIdentifier("divvy", sender: self)
    
    }
    
}