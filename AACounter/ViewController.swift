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
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
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
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("CountItem", inManagedObjectContext: self.managedObjectContext!) as! CountItem
        newItem.time=NSDate()
        newItem.device="iPhone"
        newItem.lat=50.0;
        newItem.long=55.5;
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, forState: UIControlState.Normal)
        
    }
    
    @IBAction func printNow(sender: AnyObject) {
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "CountItem")
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd-hh:mm" //format style. 
        var predicate:NSPredicate = NSPredicate(format:"time >= %@", aacDelegate.getStartTimeOfDay(NSDate()))
        
        fetchRequest.predicate=predicate
        var error: NSError?
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [CountItem] {
            
            var dateString = dateFormatter.stringFromDate(fetchResults[0].time)
            // Create an Alert, and set it's message to whatever the itemText is
            let alert = UIAlertController(title: (fetchResults.count as NSNumber).stringValue,
                message: dateString, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            alert.addAction(cancelAction)
            
            // Display the alert
            self.presentViewController(alert,
                animated: true,
                completion: nil)
        }
    }
}

