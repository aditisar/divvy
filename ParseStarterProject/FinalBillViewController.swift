//
//  FinalBillViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class FinalBillViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divvy()
    }
    
    func divvy(){

        //how to calculate cost for each user:
        
        //each user's subtotal starts at the total cost of their all of their own dishes
        //then for each of the split dishes, increment the appropriate user's subtotal
        //then look at the tax. figure out what percentage of the bill is tax. then multiply each users total by that +1
        //then multiply each user's total by the tip percentage + 1
        
        var allDishes = [PFObject]()
        
        let query = PFQuery(className:"Dish")
        query.whereKey("meal", equalTo: (Meal.curMeal?.parseObject)!) //get all dishes with this meal
        query.findObjectsInBackgroundWithBlock { (mealDishes: [PFObject]?, error: NSError?) -> Void in
            if error == nil && mealDishes != nil {
                print(mealDishes!.count)
                print("mealDishes::::", allDishes)
                allDishes += mealDishes!
                print(mealDishes![1])
                
                
                for dish in mealDishes!{
                    let cost = dish["cost"] as! Double
                    let userRelation = dish["users"]
                    userRelation.query().findObjectsInBackgroundWithBlock {
                        (users: [PFObject]?, error: NSError?) -> Void in
                        if let error = error {
                            print(error)
                            // There was an error
                            print("ERROR HERE WHEN GETTING USERS FROM RELATION")
                        } else { // if you are able to get the list of users for that dish
                            if users?.count == 1 { //if its NOT shared dish
                                let user = users!.first
                                user!["payment"] = user!["payment"] as! Double + cost
                                user!.saveInBackground()
                                print(user!["username"], " payment updated to ", user!["payment"])
                            } else { //if it is shared, iterate thru list of users
                                let splitCost = cost / Double((users?.count)!)
                                for user in users! {
                                    user["payment"] = user["payment"] as! Double + splitCost
                                    user.saveInBackground()
                                    print(user["username"], " payment updated to ", user["payment"])

                                }
                                
                                
                            }
                        }
                    } //end of looking through one dish's users
                    
                } //end looping through dishes to get each user's pre tax tip payment
                
                
                
            } else {
                print("ERROR HERE WHEN GETTING DISHES FROM CURMEAL")
                print(error)
            }
        } //end of dish query
        
//        addTax()
//        addTip()
    }
    
//    func addTax() {
//        let query = PFQuery(className:"User")
//        query.whereKey("meal", equalTo: (Meal.curMeal?.parseObject)!) //get all dishes with this meal
//        query.findObjectsInBackgroundWithBlock { (mealDishes: [PFObject]?, error: NSError?) -> Void in
//        
//            
//        
//        }
//
//    }
//    
//    func addTip(){
//        
//    }
    
    
}
