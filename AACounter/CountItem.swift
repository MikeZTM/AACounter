//
//  CountItem.swift
//  
//
//  Created by Mike Lee on 7/31/15.
//
//

import Foundation
import CoreData

class CountItem: NSManagedObject {

    @NSManaged var device: String
    @NSManaged var time: NSDate
    @NSManaged var lat: NSNumber
    @NSManaged var long: NSNumber
    @NSManaged var id: NSNumber

}
