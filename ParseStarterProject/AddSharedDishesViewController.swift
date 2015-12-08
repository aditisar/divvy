//
//  AddSharedDishesViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse


protocol SharedUsersChecked {
    func test(info:String)
}

@available(iOS 8.0, *)
class AddSharedDishesViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, SharedUsersChecked{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addDishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var dishCostTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        updateZoom()
        setupTextFieldsAndAddButton()
        receiptImageView.contentMode = .ScaleAspectFit
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        fetchImage()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //fill imageview //TODO maybe move to meal model
    func fetchImage() {
        Meal.curMeal?.parseObject
        let imageFile: PFFile = (Meal.curMeal?.parseObject["receipt"])! as! PFFile
        imageFile.getDataInBackgroundWithBlock({(result: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let image: UIImage = UIImage(data: result!)!
                self.receiptImageView.image = image
            }
        })
    }
    
    func setupTextFieldsAndAddButton(){
        dishNameTextField.delegate = self //TODO ask what this line is for
        dishCostTextField.delegate = self //TODO ask what this line is for
        dishCostTextField.keyboardType = UIKeyboardType.DecimalPad
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == dishNameTextField){
            dishCostTextField.becomeFirstResponder()
        }
        return false
    }
    
    @IBAction func showPopover(sender: AnyObject) {
        if (dishNameTextField.text != "" && dishCostTextField.text != ""){
            performSegueWithIdentifier("showPopover", sender: self)
        } else if (dishNameTextField.text == ""){
            dishNameTextField.becomeFirstResponder()
        } else if (dishCostTextField.text == ""){
            dishCostTextField.becomeFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showPopover"){
            //get rid of the keyboard before showing popover
            dishCostTextField.resignFirstResponder()
            dishNameTextField.resignFirstResponder()
            
            let vc = segue.destinationViewController as! UIViewController
            let controller = vc.popoverPresentationController
            vc.popoverPresentationController!.delegate = self
            vc.preferredContentSize = CGSize(width: 320, height: 400)
            
            if (controller != nil){
                controller?.delegate = self
            }

            let infoVC:WhichUsersViewController = segue.destinationViewController as! WhichUsersViewController
            infoVC.delegate = self

            
        }
        
        
        
    }
    
    func test(info: String){
            print(info)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    @IBAction func sharedDishesContinueButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("leaderFinishedAddingSharedDishes", sender: self)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.allUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dishCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = String(User.allUsers[indexPath.item]["username"])
        return cell
    }
    
    
    // ***************************************************************************************************
    // CODE BELOW IS NOT WRITTEN BY ME, it is from
    // https://github.com/evgenyneu/ios-imagescroll-swift
    // to allow scrolling in for the receipt image

    @IBOutlet weak var receiptImageView: UIImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = -1
    
    // Update zoom scale and constraints with animation.
    @available(iOS 8.0, *)
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            
            coordinator.animateAlongsideTransition({ [weak self] _ in
                self?.updateZoom()
                }, completion: nil)
    }
    
    //
    // Update zoom scale and constraints with animation on iOS 7.
    //
    // DEPRECATION NOTICE:
    //
    // This method is deprecated in iOS 8.0 and it is here just for iOS 7.
    // You can safely remove this method if you are not supporting iOS 7.
    // Or if you do support iOS 7 you can leave it here as it will be ignored by the newer iOS versions.
    //
    override func willAnimateRotationToInterfaceOrientation(
        toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
            
            super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
            updateZoom()
    }
    
    func updateConstraints() {
        if let image = receiptImageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            view.layoutIfNeeded()
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = receiptImageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                scrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return receiptImageView
    }
    
    // ***********************************************************************************************************
    
    
}
