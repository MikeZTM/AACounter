//
//  InterfaceController.swift
//  AACounter WatchKit Extension
//
//  Created by Mike Lee on 8/10/15.
//  Copyright (c) 2015 Mike Lee. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation


class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {

    @IBOutlet weak var btnCount: WKInterfaceButton!
    let locationManager = CLLocationManager()
    var coord : CLLocationCoordinate2D?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //App start
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        refreshCount()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func refreshCount() {
        WKInterfaceController.openParentApplication(["request": "refreshData"],
            reply: { (replyInfo, error) -> Void in
                // TODO: process reply data
                let countData = replyInfo["countData"] as? Data
                let counts = NSKeyedUnarchiver.unarchiveObject(with: countData!) as! String
                self.btnCount.setTitle(counts)
        })
    }
    
    func plusOne(){
        var location:CLLocation?
        if let loc = locationManager.location{
            location = loc
        }else{
            location = CLLocation(latitude: 0.0, longitude: 0.0)
        }
        
        WKInterfaceController.openParentApplication(["plus": NSKeyedArchiver.archivedData(withRootObject: location!)],
            reply: { (replyInfo, error) -> Void in
                // TODO: process reply data
                let countData = replyInfo["countData"] as? Data
                let counts = NSKeyedUnarchiver.unarchiveObject(with: countData!) as! String
                self.btnCount.setTitle(counts)
        })
    }
    
    @IBAction func btnPress() {
        locationManager.startUpdatingLocation()
        plusOne()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coord = manager.location!.coordinate
    }
}
