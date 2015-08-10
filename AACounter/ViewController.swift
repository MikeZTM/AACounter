//
//  ViewController.swift
//  AACounter
//
//  Created by Mike Lee on 7/31/15.
//  Copyright (c) 2015 Mike Lee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var plusBtn: UIButton!
    
    let aacDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func plusClick(sender: AnyObject) {
        aacDelegate.plusOne()
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, forState: UIControlState.Normal)
        
    }
    
    @IBAction func printNow(sender: AnyObject) {
        // Create a new fetch request using the LogItem entity
        
    }
}

