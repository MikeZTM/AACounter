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
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items = [CountItem]()
    var dateFormatter = DateFormatter()
    var highlight:IndexPath?
    var peekVC:DetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if #available(iOS 9.0, *) {
//            registerForPreviewing(with: self, sourceView: view)
//        } else {
//            // Fallback on earlier versions
//        }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel!.text = dateFormatter.string(from: items[indexPath.row].time)
        cell.detailTextLabel!.text = items[indexPath.row].device
        
        // Configure the cell...
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            managedObjectContext.delete(items[indexPath.row])
            fetchData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        highlight=indexPath;
    }
    
    
    func fetchData(){
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        
        
        dateFormatter.dateFormat =  NSLocalizedString("Date_Format", comment: "") //format style.
        // Execute the fetch request, and cast the results to an array of LogItem objects
        do{
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [CountItem] {
                items = fetchResults
            }
        }catch{
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ShowDetail") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let vc:DetailViewController = segue.destination as! DetailViewController
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

//@available(iOS 9.0, *)
//extension ListItemVC:UIViewControllerPreviewingDelegate{
//    
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
//        viewControllerForLocation location: CGPoint) -> UIViewController? {
//            if let indexPath = highlight {
//                
//                let asset:CountItem = items[indexPath.row]
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let peekController:DetailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//                let cellFrame = tableView.cellForRow(at: indexPath)!.frame
//                previewingContext.sourceRect = view.convert(cellFrame, from: tableView)
//                peekController.setItem(asset)
//                peekController.setItemList(self)
//                peekVC=peekController
//                return peekController
//            }else{
//                return nil
//            }
//    }
//    
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
//    {
//        if let peekController = peekVC {
//            self.show(peekController, sender: self)
//            return
//        }else{
//            dismiss(animated: true, completion: nil)
//            return
//        }
//    }
//}
