//
//  WaitingForMembersViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class WaitingForMembersViewController: UIViewController {
    
    var timer: NSTimer?
    var usernames = [String]();

    @IBOutlet weak var joinedMemberCount: UILabel!
    @IBOutlet weak var groupCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ever two seconds check server to see if other users have joined
        getUsernames()
        groupCode.text = Meal.curMeal?.groupCode
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("getUsernames"), userInfo: nil, repeats: true)

        print("hi", usernames)
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
    }
    
}