//
//  FirstViewController.swift
//  Time Traveler
//
//  Created by Nix, Robert P. on 7/21/16.
//  Copyright © 2016 Nix, Robert P. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBOutlet weak var dateOffset: UITextField!
    
    @IBOutlet weak var resultText: UILabel!
    
    var fmt = NSDateFormatter()
    
    
    @IBAction func todayButtonPressed(sender: AnyObject) {
        startDatePicker.date = NSDate().normalize()
        calculateDateWithOffset(startDatePicker, dateOffset: dateOffset)
    }
    
    @IBAction func startDateChanged(sender: AnyObject) {
        calculateDateWithOffset(startDatePicker, dateOffset: dateOffset)
    }
    
    @IBAction func calculatePressed(sender: AnyObject) {
        calculateDateWithOffset(startDatePicker, dateOffset: dateOffset)
    }
  
    func calculateDateWithOffset(date : UIDatePicker, dateOffset : UITextField) {
        if let offset = Int(dateOffset.text!) {
            dismissKeyboard()
            resultText.text = fmt.stringFromDate(date.date + offset.days)
        } else {
            resultText.text = fmt.stringFromDate(date.date)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startDatePicker.date = NSDate().normalize()
        
        fmt.dateFormat = "MM/dd/yyyy"
        resultText.text = fmt.stringFromDate(startDatePicker.date)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

