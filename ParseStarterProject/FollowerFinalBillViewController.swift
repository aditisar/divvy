//
//  FinalBillViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class FollowerFinalBillViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSubtotals()
    }
    
    func getSubtotals(){ //look through all users and display their payments
        User.allUsers.removeAll()
        let query = PFQuery(className:"User")
        query.whereKey("parent", equalTo: (Meal.curMeal?.parseObject)!) //get all dishes with this meal
        query.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for user in users! {
                    User.allUsers.append(user)
                }
                print(User.allUsers)
                self.tableView.reloadData()
            }
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
    
}
