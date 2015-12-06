//
//  AddDishesViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class AddDishesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        //receiptImageView.contentMode = .ScaleAspectFit
        navigationItem.title = "Add Your Own Dishes"
        fetchImage()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //fill imageview
    func fetchImage() {
        Meal.curMeal?.parseObject
        let imageFile: PFFile = (Meal.curMeal?.parseObject!["receipt"])! as! PFFile
        imageFile.getDataInBackgroundWithBlock({(result: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image: UIImage = UIImage(data: result!)!
                self.receiptImageView.image = image
            }
        })
    }
    
    
    
    
}
