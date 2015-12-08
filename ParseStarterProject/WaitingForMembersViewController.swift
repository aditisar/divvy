//
//  WaitingForMembersViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class WaitingForMembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var getUsernamesTimer: NSTimer?
    var checkMealStageTimer: NSTimer?
    var usernames = [String]();

    @IBOutlet weak var joinedMemberCount: UILabel!
    @IBOutlet weak var groupCode: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var readyToBeginButton: UIButton!
    
    @IBOutlet weak var waitingText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (User.curUser?.isLeader == true) {
            readyToBeginButton.hidden = false
        } else {
            waitingText.hidden = false
        }
        groupCode.text = Meal.curMeal?.groupCode
        //ever two seconds check server to see if other users have joined
        getUsernames()
        getUsernamesTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("getUsernames"), userInfo: nil, repeats: true)
        //only check meal status if you're not a leader otherwise get meal status will freak out bc asynch and meal might not have been created yet
        if(User.curUser!.isLeader == false) {
            checkMealStageTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkMealStage"), userInfo: nil, repeats: true)
        }
    }
    
    //updates usernames variable with list of people
    func getUsernames(){
        let query = PFQuery(className: "User")
        query.whereKey("parent", equalTo: (Meal.curMeal!.parseObject))
        query.findObjectsInBackgroundWithBlock {
            (users: [PFObject]?, error: NSError?) -> Void in
            self.usernames.removeAll()
            User.allUsers.removeAll()
            for user in users! {
                User.allUsers.append(user)
                self.usernames.append(user["username"] as! String)
            }
            if (self.usernames.count > 0) {self.readyToBeginButton.enabled = true} //TODO Make 1 when finished debugging
        }
        joinedMemberCount.text = String(usernames.count) + " member(s) have joined your party"
        print("usernames",usernames)
    
        tableview.reloadData()
    }

    //function to check what stage the cloud meal is at
    func checkMealStage(){
        let query = PFQuery(className:"Meal")
        query.getObjectInBackgroundWithId((Meal.curMeal?.parseId)!) {
            (meal: PFObject?, error: NSError?) -> Void in
            if error == nil && meal != nil {
                let status = meal!["stage"] as! Int
                if (status == Meal.BeginAddingDishes) {
                    print("Meal status has been updated to begin adding dishes! Time to segue")
                    self.readyToBeginPressed(self.readyToBeginButton)
                }
            } else {
                print("checking meal status, meal of current id not found", error)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("usernameCell", forIndexPath: indexPath) as! UITableViewCell
        //if the username is yours add an indicator
        cell.textLabel?.text = usernames[indexPath.item] == User.curUser?.username ? usernames[indexPath.item] + " (you)" : usernames[indexPath.item]
        return cell
    }
    
    @IBAction func readyToBeginPressed(sender: UIButton) {
        getUsernamesTimer!.invalidate() //stop the usernames timer
        if let _ = checkMealStageTimer {
            checkMealStageTimer!.invalidate() //stop the stage timer if it was instantiated in the first place
        } else { //if the leader physically pressed it
            Meal.curMeal?.updateParseObject("stage", val: Meal.BeginAddingDishes)
        }
        
        Meal.curMeal?.stage = Meal.BeginAddingDishes // 1
        self.performSegueWithIdentifier("beginAddingDishes", sender: self)
    }
    
    
}