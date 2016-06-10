//
//  LoginViewController.swift
//  housing
//
//  Created by Josh Burgin on 5/31/16.
//  Copyright © 2016 burgin.io. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var accessCodeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(sender: UIButton) {
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let
            deviceToken = prefs.stringForKey("deviceToken"),
            email = emailField.text
        {
            Retriever.registerDeviceToken(email, deviceToken: deviceToken)
        }
        
        performSegueWithIdentifier("transferLogin", sender: nil)
        
        /*if let
            email = emailField.text,
            accessCode = accessCodeField.text {
            
            Retriever.authenticate(email, accessCode: accessCode) { data, error in
                if let user = data {
                    if let email = user["email"].string {
                        print(email)
                    }
                    
                    if let authToken = user["authToken"].string {
                        print(authToken)
                    }
                }
                
                if let requestError = error {
                    print(requestError)
                }
            }
        }*/
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tabBarView = segue.destinationViewController as! UITabBarController
        let splitView = tabBarView.viewControllers![0] as! UISplitViewController
        let navView = splitView.viewControllers[0] as! UINavigationController
        let finalView = navView.topViewController as! MasterViewController
        
        finalView.email = emailField.text
        
    }

}
