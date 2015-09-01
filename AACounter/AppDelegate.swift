//
//  AppDelegate.swift
//  AACounter
//
//  Created by Mike Lee on 7/31/15.
//  Copyright (c) 2015 Mike Lee. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }
    
    func application(application: UIApplication,
        handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?,
        reply: (([NSObject : AnyObject]?) -> Void)) {
            // Check request info
            if let userInfo = userInfo, request = userInfo["request"] as? String {
                if request == "refreshData" {
                    // Refresh
                    let today=(countToday() as NSNumber).stringValue
                    // reply
                    reply(["countData": NSKeyedArchiver.archivedDataWithRootObject(today)])
                    return
                } 
            }
            if let userInfo = userInfo, request = userInfo["plus"] as? NSData{
                let loc = request
                let location = NSKeyedUnarchiver.unarchiveObjectWithData(loc) as! CLLocation
                plusOne(location.coordinate)
                let today=(countToday() as NSNumber).stringValue
                // reply
                reply(["countData": NSKeyedArchiver.archivedDataWithRootObject(today)])
                return
            }
            // return null
            reply(["countData":NSKeyedArchiver.archivedDataWithRootObject("Err")])
    }

    func countToday() -> Int {
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "CountItem")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd-hh:mm" //format style. Browse online to get a format that fits your needs.
        let predicate:NSPredicate = NSPredicate(format:"time >= %@", getStartTimeOfDay(NSDate()))
        
        fetchRequest.predicate=predicate
        // Execute the fetch request, and cast the results to an array of LogItem objects
        do{
            if let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [CountItem] {
                return fetchResults.count
            }
        }catch{
        }
        return 0
    }
    
    func getStartTimeOfDay(day: NSDate) -> NSDate{
        let now:NSDate = day
        let calendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: now)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let newDate:NSDate = calendar.dateFromComponents(components)!
        return newDate
    }
    
    func plusOne(coord: CLLocationCoordinate2D?) {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("CountItem", inManagedObjectContext: self.managedObjectContext!) as! CountItem
        newItem.time=NSDate()
        newItem.device=""
        if let _coord = coord{
            newItem.lat = _coord.latitude
            newItem.long = _coord.longitude
        }else{
            newItem.lat = 0.0
            newItem.long = 0.0
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "org.zasaz.AACounter" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("AACounter", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("AACounter.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

