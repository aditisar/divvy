//
//  FollowerWaitScreenViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class FollowerWaitScreenViewController: UIViewController{
    
    var checkMealStageTimer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkMealStageTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkMealStage"), userInfo: nil, repeats: true)

    }
    
    func checkMealStage(){
        print("checking meal stage")
        let query = PFQuery(className:"Meal")
        query.getObjectInBackgroundWithId((Meal.curMeal?.parseId)!) {
            (meal: PFObject?, error: NSError?) -> Void in
            if error == nil && meal != nil {
                let status = meal!["stage"] as! Int
                print("status", status)
                if (status == Meal.FinishedCalculations) {
                    print("meal final stage reached")
                    self.finalStageReached()
                }
            } else {
                print("checking meal status, meal of current id not found", error)
            }
        }
    }
    
    
    func finalStageReached() {
        print("invldated timer calle segue")
        checkMealStageTimer?.invalidate()
        performSegueWithIdentifier("showFollowerFinalBill", sender: self)
    }

    
}

