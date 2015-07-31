//
//  CounterItem.swift
//  
//
//  Created by Mike Lee on 7/30/15.
//
//

import Foundation
import CoreData

class CounterItem: NSManagedObject {

    @NSManaged var time: NSNumber
    @NSManaged var loactionlatitude: NSNumber
    @NSManaged var locationlongitude: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var brief: String
    @NSManaged var device: String

}
