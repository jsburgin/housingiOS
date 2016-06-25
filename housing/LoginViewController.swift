//
//  LoginViewController.swift
//  housing
//
//  Created by Josh Burgin on 5/31/16.
//  Copyright © 2016 burgin.io. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var accessCodeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            let idToken = user.authentication.idToken // Safe to send to the server
            
            Retriever.authenticate(idToken) { data, error in
                
                if let error = error {
                    print(error)
                }
                
                if let googleEmail = data?["email"].string,
                    let apiKey = data?["apiKey"].string {
                    
                    let prefs = NSUserDefaults.standardUserDefaults()
                    
                    prefs.setValue(apiKey, forKey: "apiKey")
                    prefs.setValue(googleEmail, forKey: "email")
                    
                    if let
                        deviceToken = prefs.stringForKey("deviceToken")
                    {
                        Retriever.registerDeviceToken(googleEmail, deviceToken: deviceToken)
                    }
                    
                    self.performSegueWithIdentifier("transferLogin", sender: nil)
                }
            }
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        
    }

}
