//
//  DetailViewController.swift
//  
//
//  Created by Mike Lee on 8/11/15.
//
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    var _item:CountItem?
    var dateFormatter = NSDateFormatter()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteInput: UITextField!
    @IBOutlet weak var keyboardSpace: NSLayoutConstraint!
    var itemListVC: ListItemVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loc = CLLocation(latitude: _item!.lat as Double, longitude: _item!.long as Double)
        centerMapOnLocation(loc)
        // show pin on map
        dateFormatter.dateFormat = NSLocalizedString("Date_Format", comment: "")
        let pin = CountPlace(title: dateFormatter.stringFromDate(_item!.time),
            locationName: "",
            discipline: "",
            coordinate: CLLocationCoordinate2D(latitude: _item!.lat as Double, longitude: _item!.long as Double))
        mapView.addAnnotation(pin)
        
        // edit label
        titleLabel.text = dateFormatter.stringFromDate(_item!.time)
        noteInput.text = _item?.device
        noteInput.returnKeyType = .Done
        noteInput.delegate = self
        
        
        // keyboard layout
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setItemList(list: ListItemVC){
        self.itemListVC = list
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setItem(val:CountItem) {
        _item = val
    }
    
    @IBAction func editNote(sender: AnyObject) {
        _item?.device = noteInput.text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func editEnd(sender: AnyObject) {
       _item?.device = noteInput.text!
    }
    
    func keyboardWillShow(notification: NSNotification){
        let info: NSDictionary = notification.userInfo!
        let kbFrame: NSValue = info.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let animationDuration: NSTimeInterval = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)!.doubleValue
        let keyboardFrame:CGRect = kbFrame.CGRectValue()
        let height: CGFloat = keyboardFrame.size.height
        // Because the "space" is actually the difference between the bottom lines of the 2 views,
        // we need to set a negative constant value here.
        self.keyboardSpace.constant = 50 + height;
        
        UIView.animateWithDuration(animationDuration, animations: {
            self.view.layoutIfNeeded
        })
    }
    
    func keyboardWillHide(notification: NSNotification){
        let info: NSDictionary = notification.userInfo!
        let animationDuration: NSTimeInterval = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)!.doubleValue
        self.keyboardSpace.constant = 50;
        UIView.animateWithDuration(animationDuration, animations: {
            self.view.layoutIfNeeded
        })
    }
    
    override func viewWillDisappear(animated:Bool){
        if let itemListVC = itemListVC {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                itemListVC.tableView.reloadData()
            })
        }
        super.viewWillDisappear(animated)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
