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
    var shortcut: Bool = false
    var shortcurdes: NSString?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
                shortcut = true
                if handleShortCutItem(shortcutItem) {
                    
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
    }
    
    @available(iOS 9.0, *)
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        if self.shortcut == true {
            return shortcut
        }
        var handled = false
        let rootNavigationViewController = window!.rootViewController as? UINavigationController
        if let rootViewController = rootNavigationViewController?.viewControllers.first as! ViewController?{
            //Pop to root view controller so that approperiete segue can be performed
            rootNavigationViewController?.popToRootViewController(animated: false)
            rootViewController.plusClick(self)
            handled = true;
        }
        return handled
    }
    
    
//    func application(_ application: UIApplication,
//        handleWatchKitExtensionRequest userInfo: [AnyHashable: Any]?,
//        reply: (@escaping ([AnyHashable: Any]?) -> Void)) {
//            // Check request info
//            if let userInfo = userInfo, let request = userInfo["request"] as? String {
//                if request == "refreshData" {
//                    // Refresh
//                    let today=(countToday() as NSNumber).stringValue
//                    // reply
//                    reply(["countData": NSKeyedArchiver.archivedData(withRootObject: today)])
//                    return
//                }
//            }
//            if let userInfo = userInfo, let request = userInfo["plus"] as? Data{
//                let loc = request
//                let location = NSKeyedUnarchiver.unarchiveObject(with: loc) as! CLLocation
//                plusOne(location.coordinate)
//                let today=(countToday() as NSNumber).stringValue
//                // reply
//                reply(["countData": NSKeyedArchiver.archivedData(withRootObject: today)])
//                return
//            }
//            // return null
//            reply(["countData":NSKeyedArchiver.archivedData(withRootObject: "Err")])
//    }
    
    func countToday() -> Int {
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountItem")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd-hh:mm" //format style. Browse online to get a format that fits your needs.
        let predicate:NSPredicate = NSPredicate(format:"time >= %@", getStartTimeOfDay(Date()) as CVarArg)
        
        fetchRequest.predicate=predicate
        // Execute the fetch request, and cast the results to an array of LogItem objects
        do{
            if let fetchResults = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [CountItem] {
                return fetchResults.count
            }
        }catch{
        }
        return 0
    }
    
    func getStartTimeOfDay(_ day: Date) -> Date{
        let now:Date = day
        let calendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: now)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let newDate:Date = calendar.date(from: components)!
        return newDate
    }
    
    func plusOne(_ coord: CLLocationCoordinate2D?) {
        let managedContext = self.persistentContainer.viewContext
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "CountItem", into: managedContext) as! CountItem
        newItem.time=Date()
        newItem.device=""
        if let _coord = coord{
            newItem.lat = NSNumber(value: _coord.latitude)
            newItem.long = NSNumber(value: _coord.longitude)
        } else {
            newItem.lat = 0.0
            newItem.long = 0.0
        }
        saveContext()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "AACounter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

