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
    var dateFormatter = DateFormatter()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteInput: UITextField!
    @IBOutlet weak var keyboardSpace: NSLayoutConstraint!
    var itemListVC: ListItemVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loc = CLLocation(latitude: _item!.lat as! Double, longitude: _item!.long as! Double)
        centerMapOnLocation(loc)
        // show pin on map
        dateFormatter.dateFormat = NSLocalizedString("Date_Format", comment: "")
        let pin = CountPlace(title: dateFormatter.string(from: _item!.time),
            locationName: "",
            discipline: "",
            coordinate: CLLocationCoordinate2D(latitude: _item!.lat as! Double, longitude: _item!.long as! Double))
        mapView.addAnnotation(pin)
        
        // edit label
        titleLabel.text = dateFormatter.string(from: _item!.time)
        noteInput.text = _item?.device
        noteInput.returnKeyType = .done
        noteInput.delegate = self
        
        
        // keyboard layout
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setItemList(_ list: ListItemVC){
        self.itemListVC = list
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
            latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setItem(_ val:CountItem) {
        _item = val
    }
    
    @IBAction func editNote(_ sender: AnyObject) {
        _item?.device = noteInput.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func editEnd(_ sender: AnyObject) {
       _item?.device = noteInput.text!
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let kbFrame: NSValue = info.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let animationDuration: TimeInterval = (info.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey)! as AnyObject).doubleValue
        let keyboardFrame:CGRect = kbFrame.cgRectValue
        let height: CGFloat = keyboardFrame.size.height
        // Because the "space" is actually the difference between the bottom lines of the 2 views,
        // we need to set a negative constant value here.
        self.keyboardSpace.constant = 50 + height;
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let animationDuration: TimeInterval = (info.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey)! as AnyObject).doubleValue
        self.keyboardSpace.constant = 50;
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillDisappear(_ animated:Bool){
        if let itemListVC = itemListVC {
            DispatchQueue.main.async(execute: { () -> Void in
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
    
//    @available(iOS 9.0, *)
//    var previewActions: [UIPreviewActionItem]
//        {
//            return [UIPreviewAction(title: "Remove",
//                style: UIPreviewActionStyle.Default,
//                handler:
//                {
//                    (previewAction, viewController) in (viewController as? PeekViewController)?.toggleFavourite()
//            })]
//    }
}
