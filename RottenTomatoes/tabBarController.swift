//
//  tabBarController.swift
//  RottenTomatoes
//
//  Created by Siyu Song on 2/8/15.
//  Copyright (c) 2015 Siyu-CodePath. All rights reserved.
//

import UIKit
//import navigationController

class tabBarController: UITabBarController, UITabBarControllerDelegate, UITabBarDelegate {

    @IBOutlet weak var listTypeTab: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (self.selectedIndex)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.tabIndex = self.selectedViewController?.tabBarItem.tag as Int!
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
