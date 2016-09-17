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
    
    var fmt = DateFormatter()
    
    
    @IBAction func todayButtonPressed(_ sender: AnyObject) {
        startDatePicker.date = Date().normalize()
        calculateDateWithOffset(startDatePicker, dateOffset: dateOffset)
    }
    
    @IBAction func startDateChanged(_ sender: AnyObject) {
        calculateDateWithOffset(startDatePicker, dateOffset: dateOffset)
    }
    
    @IBAction func calculatePressed(_ sender: AnyObject) {
        calculateDateWithOffset(startDatePicker, dateOffset: dateOffset)
    }
  
    func calculateDateWithOffset(_ date : UIDatePicker, dateOffset : UITextField) {
        if let offset = Int(dateOffset.text!) {
            dismissKeyboard()
            resultText.text = fmt.string(from: date.date + offset.days)
        } else {
            resultText.text = fmt.string(from: date.date)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startDatePicker.date = Date().normalize()
        
        fmt.dateFormat = "MM/dd/yyyy"
        resultText.text = fmt.string(from: startDatePicker.date)
        
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

