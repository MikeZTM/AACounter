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
    var locationManager : CLLocationManager?
    var coord : CLLocationCoordinate2D?
    
    let aacDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        if(aacDelegate.shortcut==true){
            self.plusClick(self)
            aacDelegate.shortcut=false
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, for: UIControlState())
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(ViewController.appCameToForeground(_:)),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func plusClick(_ sender: AnyObject) {
        if let location = locationManager?.location {
            aacDelegate.plusOne(location.coordinate)
        }else{
            aacDelegate.plusOne(nil)
        }
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, for: UIControlState())
        
    }
    
    func appCameToForeground(_ notification: Notification){
        plusBtn.setTitle((aacDelegate.countToday() as NSNumber).stringValue, for: UIControlState())
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        coord = manager.location!.coordinate
    }
}

