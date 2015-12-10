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
    
    @IBOutlet weak var screenshotButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSubtotals()
    }
    
    func getSubtotals(){ //look through all users and display their payments
        User.allUsers.removeAll()
        var total = 0.0
        let query = PFQuery(className:"User")
        query.whereKey("parent", equalTo: (Meal.curMeal?.parseObject)!) //get all dishes with this meal
        query.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for user in users! {
                    User.allUsers.append(user)
                    total += user["payment"] as! Double
                }
                print(User.allUsers)
                self.tableView.reloadData()
                self.totalLabel.text = String(format:"$%.2f", total)
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
    
    @IBAction func startOver(sender: AnyObject) {
        performSegueWithIdentifier("followerStartOver", sender: self)
    }
    
    
    @IBAction func saveScreenshot(sender: AnyObject) {
        screenShotMethod()
        screenshotButton.enabled = false
        screenshotButton.setTitle("saved!", forState: .Disabled)
        screenshotButton.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.80, alpha:1.0)
    }
    
    //http://stackoverflow.com/questions/25448879/how-to-take-full-screen-screenshot-in-swift
    func screenShotMethod() {
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
    }
    
}
