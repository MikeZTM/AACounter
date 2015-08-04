//
//  NaviC.swift
//  
//
//  Created by Mike Lee on 8/3/15.
//
//

import UIKit

class NaviC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.6)
        self.navigationBar.translucent = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
