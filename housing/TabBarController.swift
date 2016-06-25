//
//  TabBarController.swift
//  housing
//
//  Created by Josh Burgin on 6/25/16.
//  Copyright © 2016 burgin.io. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var apiKey: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let apiKey = prefs.stringForKey("apiKey") {
            self.apiKey = apiKey
        } else {
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("requireLogin", sender: self)
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
