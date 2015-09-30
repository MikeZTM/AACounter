//
//  ListItemVC.swift
//
//
//  Created by Mike Lee on 8/3/15.
//
//

import UIKit
import CoreData

class ListItemVC: UITableViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var items = [CountItem]()
    var dateFormatter = NSDateFormatter()
    var highlight:NSIndexPath?
    var peekVC:DetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 9.0, *) {
            registerForPreviewingWithDelegate(self, sourceView: view)
        } else {
            // Fallback on earlier versions
        }
        fetchData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)
        cell.textLabel!.text = dateFormatter.stringFromDate(items[indexPath.row].time)
        cell.detailTextLabel!.text = items[indexPath.row].device
        
        // Configure the cell...
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext?.deleteObject(items[indexPath.row])
            fetchData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        highlight=indexPath;
    }
    
    
    func fetchData(){
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "CountItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        
        
        dateFormatter.dateFormat =  NSLocalizedString("Date_Format", comment: "") //format style.
        // Execute the fetch request, and cast the results to an array of LogItem objects
        do{
            if let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [CountItem] {
                items = fetchResults
            }
        }catch{
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowDetail") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let vc:DetailViewController = segue.destinationViewController as! DetailViewController
            vc.setItem(items[indexPath.row])
            vc.setItemList(self)
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

@available(iOS 9.0, *)
extension ListItemVC:UIViewControllerPreviewingDelegate{
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            if let indexPath = highlight {
                
                let asset:CountItem = items[indexPath.row]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let peekController:DetailViewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
                let cellFrame = tableView.cellForRowAtIndexPath(indexPath)!.frame
                previewingContext.sourceRect = view.convertRect(cellFrame, fromView: tableView)
                peekController.setItem(asset)
                peekController.setItemList(self)
                peekVC=peekController
                return peekController
            }else{
                return nil
            }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController)
    {
        if let peekController = peekVC {
            self.showViewController(peekController, sender: self)
            return
        }else{
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
    }
}
