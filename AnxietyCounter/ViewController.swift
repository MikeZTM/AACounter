//
//  ViewController.swift
//  AnxietyCounter
//
//  Created by Mike Lee on 7/30/15.
//  Copyright (c) 2015 Mike Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Print it to the console
        println(managedObjectContext)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
