//
//  GlanceController.swift
//  AACounter WatchKit Extension
//
//  Created by Mike Lee on 8/10/15.
//  Copyright (c) 2015 Mike Lee. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet weak var counter: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //init
        
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
                let countData = replyInfo["countData"] as? NSData
                let counts = NSKeyedUnarchiver.unarchiveObjectWithData(countData!)
                self.counter.setText(counts as? String)
        })
    }
}
