//
//  InterfaceController.swift
//  AACounter WatchKit Extension
//
//  Created by Mike Lee on 8/10/15.
//  Copyright (c) 2015 Mike Lee. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        WKInterfaceController.openParentApplication(["request": "refreshData"],
            reply: { (replyInfo, error) -> Void in
                // TODO: process reply data
                NSLog("Reply: \(replyInfo)")
        })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func btnPress() {
        
    }
}
