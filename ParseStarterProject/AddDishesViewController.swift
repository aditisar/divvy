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
        setupTextFieldsAndAddButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
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
    
    func setupTextFieldsAndAddButton(){
        dishNameTextField.delegate = self //TODO ask what this line is for
        dishCostTextField.delegate = self //TODO ask what this line is for
        dishCostTextField.keyboardType = UIKeyboardType.DecimalPad
    }
    
    func isDishValid() -> Bool{
        if (dishNameTextField.text == ""){
            return false
        } else if (dishCostTextField.text == ""){
            return false
        }
        return true
    }
    
    
    @IBAction func addDishTapped(sender: AnyObject) {
        if (dishNameTextField.text != "" && dishCostTextField.text != ""){
            //local
            let dish = Dish(name: dishNameTextField.text!, cost: Double(dishCostTextField.text!)!, meal: (Meal.curMeal?.parseObject)!)
            Meal.curMeal?.dishes.append(dish)
            print("list of local dishes for cur meal", Meal.curMeal?.dishes)
            self.tableView.reloadData()
            print("Table should have updated..")
            if let a = User.curUser {
                print("not erroring on this")
                dish.users.append(User.curUser!)
            }

            //parse
            //don't need to do parse because it happens in dish init..
            dishNameTextField.becomeFirstResponder()
            
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Meal.curMeal?.dishes.count)! //TODO REPLACE W DISHES ARRAY LENGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dishCell", forIndexPath: indexPath) as! UITableViewCell
        print("in tableview method")
        print(Meal.curMeal?.dishes[indexPath.item].name)
        cell.textLabel?.text = Meal.curMeal?.dishes[indexPath.item].name
        return cell
    }
    

}
