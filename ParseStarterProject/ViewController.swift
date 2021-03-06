/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.username.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //hide the nav bar on this page
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func createGroupPressed(sender: AnyObject){
        if username.text!.characters.count > 0 {
            
            //make a meal
            let meal = Meal(groupCode: Meal.generateGroupCode())
            meal.saveToParse()
            Meal.curMeal = meal
            
            
            //make a user that is a leader
            let name = username.text!
            let leader: User = User(username: name)
            leader.isLeader = true
            leader.meal = Meal.curMeal?.parseObject
            //save both meal and leader to parse
            leader.saveToParse()
            User.curUser = leader
            self.performSegueWithIdentifier("userCreatedParty", sender: self)
            
        } else {
            username.becomeFirstResponder()
        }
        
        
        
    }
    
    @IBAction func joinGroupPressed(sender: AnyObject) {
        if username.text!.characters.count > 0 {
            //make a user that is a follower
            let name = username.text!
            let follower: User = User(username: name)
            follower.saveToParse()
            self.performSegueWithIdentifier("userWillJoinParty", sender: self)
        } else {
            username.becomeFirstResponder()
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        username.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    
}
