//
//  UploadReceiptViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class UploadReceiptViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var groupCode: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var retakeLabel: UILabel!
    @IBOutlet weak var uploadText: UILabel!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var retakePictureButton: UIButton!
    
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        groupCode.text = Meal.curMeal!.groupCode
        self.nextButton.enabled = false
        self.retakeLabel.hidden = true
        
    }
    
    @IBAction func takePicture(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let receiptImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        currentImage.contentMode = .ScaleAspectFit
        currentImage.image = receiptImage
        self.takePictureButton.hidden = true //hide the original take photo button
        self.uploadText.hidden = true
        self.nextButton.enabled = true
        self.retakePictureButton.hidden = false //show the retake one
        self.retakeLabel.hidden = false
        
        self.dismissViewControllerAnimated(true, completion: {
            print("dismissing photo vc")
        })
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        let imageData = UIImageJPEGRepresentation(currentImage.image!, 0.2)
        let imageFile = PFFile(name:"image.jpeg", data:imageData!)

//        let imageFile:PFFile = PFFile(data: UIImagePNGRepresentation(currentImage.image!, 0.2)!)!
        Meal.curMeal!.parseObject!["receipt"] = imageFile
        Meal.curMeal!.parseObject!.saveInBackground()
        performSegueWithIdentifier("receiptUploaded", sender: self)
    }
    
}