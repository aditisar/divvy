//
//  AddDishesViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class AddDishesViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addDishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var dishCostTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        //dishCostTextField.delegate = self //TODO ask what this line is for
        dishCostTextField.keyboardType = UIKeyboardType.DecimalPad

        //receiptImageView.contentMode = .ScaleAspectFit
        navigationItem.title = "Add Your Own Dishes"
        fetchImage()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //fill imageview
    func fetchImage() {
        Meal.curMeal?.parseObject
        let imageFile: PFFile = (Meal.curMeal?.parseObject!["receipt"])! as! PFFile
        imageFile.getDataInBackgroundWithBlock({(result: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image: UIImage = UIImage(data: result!)!
                self.receiptImageView.image = image
            }
        })
    }
    
    
    @IBAction func addDishTapped(sender: AnyObject) {
        let conditions = true
        if (conditions == true) { //REPLACE WITH ACTUAL CONDITIONS TO MAKE SURE DISH IS PROPERLY ENTERED
            let dish = Dish(name: dishNameTextField.text!, cost: Double(dishCostTextField.text!)!)
            Meal.curMeal?.dishes.append(dish)
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dishCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = ["a","a","a"][indexPath.item] //TODO REPLACE WITH DISHES ARRAY
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //TODO REPLACE W DISHES ARRAY LENGHT
    }
}
