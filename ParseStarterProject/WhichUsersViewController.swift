//
//  WhichUsersViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class WhichUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    //delegate protocol for sending who shared back to add shared dishes vc
    var delegate: SharedUsersChecked? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.allUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("usernameCell", forIndexPath: indexPath) as! WhoSharedCell
        
        cell.usernameLabel.text = String(User.allUsers[indexPath.item]["username"])
        return cell
    }
    
    @IBAction func addSharedDish(sender: AnyObject) {
        if (delegate != nil) {
            var peopleWhoSharedIndices = [Int]()
            for row in 0..<tableView.numberOfRowsInSection(0) {
                
                let indexPath = NSIndexPath(forRow: row, inSection: 0)
                var cell = tableView.cellForRowAtIndexPath(indexPath) as! WhoSharedCell
                if cell.sharedSwitch.on {
                    peopleWhoSharedIndices.append(indexPath.item)
                }
                
            }
            
            print("people who shared indicies", peopleWhoSharedIndices)
            
            delegate!.addSharedDish(peopleWhoSharedIndices)
            let parent :UIViewController! = self.presentingViewController;
            
            self.dismissViewControllerAnimated(false, completion: {()->Void in
                parent.dismissViewControllerAnimated(false, completion: nil);
            });
        }


    }
}
