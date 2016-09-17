//
//  SecondViewController.swift
//  Time Traveler
//
//  Created by Nix, Robert P. on 7/21/16.
//  Copyright © 2016 Nix, Robert P. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var differenceText: UILabel!
        
    @IBAction func todayButtonPressed(_ sender: AnyObject) {
        startDatePicker.date = Date().normalize()
        calculateDifference()
    }
    
    @IBAction func startDateChanged(_ sender: AnyObject) {
        calculateDifference()
    }
    
    @IBAction func endDateChanged(_ sender: AnyObject) {
        calculateDifference()
    }
    
    func calculateDifference() -> Void {
        let difference = startDatePicker.date.diff(endDatePicker.date)
        differenceText.text = ""
        if difference.year != 0 {
            differenceText.text = " \(difference.year!) year"
            if difference.year != 1 && difference.year != -1 {
                differenceText.text = differenceText.text! + "s"
            }
        }
        if difference.month != 0 {
            differenceText.text = differenceText.text! +
                " \(difference.month!) month"
            if difference.month != 1 && difference.month != -1 {
                differenceText.text = differenceText.text! + "s"
            }
        }
        if difference.day != 0 {
            differenceText.text = differenceText.text! +
                " \(difference.day!) day"
            if difference.day != 1 && difference.day != -1 {
                differenceText.text = differenceText.text! + "s"
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       differenceText.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

