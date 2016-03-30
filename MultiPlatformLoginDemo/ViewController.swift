//
//  ViewController.swift
//  MultiPlatformLoginDemo
//
//  Created by Shivam Kapur on 28/03/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance().clientID = "212926967035-aiighbnnhdrmd545q9k436ekggt0o3le.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let err = error {
            print(err)
        }
        else {
            performSegueWithIdentifier("loggedIn", sender: self)
        }
    }

    @IBAction func facebookLoginPressed(sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["public_profile"], fromViewController: self) { (result: FBSDKLoginManagerLoginResult!,error: NSError!) in
            
            if error != nil {
                self.showAlert("Error Occured", message: "\(error.debugDescription)")
            }   else if result.isCancelled {
                self.showAlert("Login Cancelled", message: "Error Occured. Please try again")
            }   else {
                print("Called")
                self.performSegueWithIdentifier("loggedIn", sender: nil)
            }

        }
    }
    
    @IBAction func linkedInLoginTapped(sender: AnyObject) {
        LISDKSessionManager.createSessionWithAuth([LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            print("success called!")
            print(LISDKSessionManager.sharedInstance().session)
            
            let url = "https://api.linkedin.com/v1/people/~"
            
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) -> Void in
                    print(response)
                    }, error: { (error) -> Void in
                        print(error)
                })
            }
            
            
        }) { (error) -> Void in
            print("Error: \(error)")
        }
    }
    
    func showAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

