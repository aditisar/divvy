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
    
    var timer: NSTimer?
    var usernames = [String]();

    @IBOutlet weak var joinedMemberCount: UILabel!
    @IBOutlet weak var groupCode: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupCode.text = Meal.curMeal?.groupCode
        //ever two seconds check server to see if other users have joined
        getUsernames()
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("getUsernames"), userInfo: nil, repeats: true)
    }
    
    //updates usernames variable with list of people
    func getUsernames(){
        print("running getUsernames")
        let query = PFQuery(className: "User")
        query.whereKey("parent", equalTo: (Meal.curMeal!.parseObject)!)
        query.findObjectsInBackgroundWithBlock {
            (users: [PFObject]?, error: NSError?) -> Void in
            self.usernames.removeAll()
            for user in users! {
                self.usernames.append(user["username"] as! String)
            }
        }
        joinedMemberCount.text = String(usernames.count) + " member(s) have joined your party"
        print(usernames)
        tableview.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("usernameCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = usernames[indexPath.item] == User.curUser?.username ? usernames[indexPath.item] + " (you)" : usernames[indexPath.item]
        return cell
    }
    
}