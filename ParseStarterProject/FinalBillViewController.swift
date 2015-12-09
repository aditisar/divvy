//
//  FinalBillViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class FinalBillViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divvy()
    }
    
    func divvy(){

        //how to calculate cost for each user:
        
        //look through each dish , if it has one user, add the cost of the dish to that user's payment
        //otherwise iterate thru list of it's users and add the split cost to each
        //then for each of the split dishes, increment the appropriate user's subtotal
        //then look at the tax. figure out what percentage of the bill is tax. then multiply each users total by that +1
        //then multiply each user's total by the tip percentage + 1
        
        var allDishes = [PFObject]()
        
        let query = PFQuery(className:"Dish")
        query.whereKey("meal", equalTo: (Meal.curMeal?.parseObject)!) //get all dishes with this meal
        query.findObjectsInBackgroundWithBlock { (mealDishes: [PFObject]?, error: NSError?) -> Void in
            if error == nil && mealDishes != nil {
                allDishes += mealDishes!
                print("mealDishes::::", allDishes)
                let
                numDishes = mealDishes!.count
            
                for (index,dish) in mealDishes!.enumerate(){
                    let cost = dish["cost"] as! Double
                    let userRelation = dish["users"]
                    userRelation.query().findObjectsInBackgroundWithBlock {
                        (users: [PFObject]?, error: NSError?) -> Void in
                        if let error = error {
                            print(error)
                            // There was an error
                        } else {
                            let splitCost = cost / Double((users?.count)!)
                                for user in users! {
                                    user["payment"] = user["payment"] as! Double + splitCost
                                    do {
                                        try user.save()
                                    } catch {
                                        print("user couldnt save in shared dish", error)
                                    }
                                    print(user["username"], " payment updated to ", user["payment"],"with split cost of", dish["name"])
                                }
                                
                            //}
                        }
                        //if finished with the last dish, then call add tax
                        //has to be here because of asynchronousness - needs to be inside innermost background query
                        if (index == mealDishes!.count - 1){
                            self.addTax()
                        }
                    } //end of users query
                }
            } else {
                print(error)
            }
        } //end of dish query

    }
    
    
    
    func addTax() {
        print("************************* Now calculating tax")
        let taxPercentage = (Meal.curMeal?.tax)! / (Meal.curMeal?.groupTotal)!
        print("tax percentage is", taxPercentage)
        let query = PFQuery(className:"User")
        query.whereKey("parent", equalTo: (Meal.curMeal?.parseObject)!) //get all users in the meal
        query.findObjectsInBackgroundWithBlock { (mealUsers: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                for user in mealUsers! {
                    user["payment"] = user["payment"] as! Double * (1 + taxPercentage)
                    do {
                        try user.save()
                    } catch {
                        print("user couldnt save in tax", error)
                    }
                    print(user["username"], "amount with tax", user["payment"])
                }
            }
            //putting it here so doesn't mess with asynch. only happens after all users pretip has been calculated
            self.addTip()
        }
    }
    
    
    
    func addTip(){
        print("************************* Now calculating tip")
        let tipPercentage = round( 100 * (Meal.curMeal?.tip)! ) / 100
        print("tip percentage is", tipPercentage)
        let query = PFQuery(className:"User")
        query.whereKey("parent", equalTo: (Meal.curMeal?.parseObject)!) //get all users in the meal
        query.findObjectsInBackgroundWithBlock { (mealUsers: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                for user in mealUsers! {
                    user["payment"] = user["payment"] as! Double * (1 + tipPercentage)
                    do {
                        try user.save()
                    } catch {
                        print("user couldnt save in tip", error)
                    }
                    print(user["username"], "final amount with tax and tip", user["payment"])
                }
            }
            //putting it here so doesn't mess with asynch. only happens after all everything has been calculated
            self.getFinalPayments()
        }
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.allUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("subtotalCell", forIndexPath: indexPath) as! UITableViewCell
        let username = String(User.allUsers[indexPath.item]["username"])
        var payment = User.allUsers[indexPath.item]["payment"] as! Double
        payment = round( 100 * payment ) / 100
        cell.textLabel?.text = String(format:"\(username)    $%.2f", payment
        )
        return cell
    }
    
    func getFinalPayments(){
        print("in get final payments")
        User.allUsers.removeAll()

        let query = PFQuery(className:"User")
        query.whereKey("parent", equalTo: (Meal.curMeal?.parseObject)!) //get all users in the meal
        query.findObjectsInBackgroundWithBlock { (mealUsers: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                for user in mealUsers! {
                    User.allUsers.append(user)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
}
