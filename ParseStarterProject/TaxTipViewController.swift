//
//  TaxTipViewController.swift
//  Divvy
//
//  Created by Aditi Sarkar on 12/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class TaxTipViewController: UIViewController {
    
    @IBOutlet weak var groupTotal: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipSliderLabel: UILabel!
    @IBOutlet weak var roundUpSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let total = 30.00 //change to actual total
        groupTotal.text = "Group Total: $0.00" // + \(total)"
    }
    

    @IBAction func tipSliderChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        tipSliderLabel.text = "\(currentValue) %"
    }
    
    @IBAction func calculateAmountsPressed(sender: AnyObject) {
        
    }
    
}