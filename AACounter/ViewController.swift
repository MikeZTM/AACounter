//
//  ViewController.swift
//  AACounter
//
//  Created by Mike Lee on 7/31/15.
//  Copyright (c) 2015 Mike Lee. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var plusBtn: UIButton!
    var locationManager : CLLocationManager!
    var coord : CLLocationCoordinate2D?
    
    let aacDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, forState: UIControlState.Normal)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "appCameToForeground:",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func plusClick(sender: AnyObject) {
        aacDelegate.plusOne(locationManager.location.coordinate)
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, forState: UIControlState.Normal)
        
    }
    
    func appCameToForeground(notification: NSNotification){
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, forState: UIControlState.Normal)
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]!) {
        coord = manager.location.coordinate
    }
}

