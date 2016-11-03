//
//  ViewController.swift
//  projectNYiT
//
//  Created by Soji Balogun on 10/30/16.
//  Copyright © 2016 Soji Balogun. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupData()
        authenticateUser()
    }
    
    
    func setupData() {
        self.statusLabel.text = "Unknown user"
    }
    
    
    func authenticateUser() {
        let touchIDManager = TouchIDManager()
        
        
        touchIDManager.authenticateUser(success: { () -> () in
            OperationQueue.main.addOperation({ () -> Void in
                self.loadDada()
            })
        }, failure: { (evaluationError: NSError) -> () in
            switch evaluationError.code {
            case LAError.Code.systemCancel.rawValue:
                print("Authentication cancelled by the system")
                self.statusLabel.text = "Authentication cancelled by the system"
            case LAError.Code.userCancel.rawValue:
                print("Authentication cancelled by the user")
                self.statusLabel.text = "Authentication cancelled by the user"
            case LAError.Code.userFallback.rawValue:
                print("User wants to use a password")
                self.statusLabel.text = "User wants to use a password"
                
                // We show the alert view in the main thread (always update the UI in the main thread)
                OperationQueue.main.addOperation({ () -> Void in
                    self.showPasswordAlert()
                })
            case LAError.Code.touchIDNotEnrolled.rawValue:
                print("TouchID not setup")
                self.statusLabel.text = "TouchID not setup"
            case LAError.Code.passcodeNotSet.rawValue:
                print("Passcode not set")
                self.statusLabel.text = "Passcode not set"
            default:
                print("Authentication failed")
                self.statusLabel.text = "Authentication failed"
                OperationQueue.main.addOperation({ () -> Void in
                    self.showPasswordAlert()
                })
            }
        })
    }
    
    
    func loadDada() {
        self.statusLabel.text = "User authenticated"
    }
    
    
    func showPasswordAlert() {
        // New way to present an alert view using UIAlertController
        let alertController = UIAlertController(title:"TouchID Demo",
                                                message: "Please enter password",
                                                preferredStyle: .alert)
        
        
        // We define the actions to add to the alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print(action)
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) -> Void in
            let passwordTextField = alertController.textFields![0] as UITextField
            if let text = passwordTextField.text {
                self.login(text)
            }
        }
        doneAction.isEnabled = false
        
        
        // We are customizing the text field using a configuration handler
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using: { (notification) -> Void in
                doneAction.isEnabled = textField.text != ""
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        
        self.present(alertController, animated: true) {
            // Nothing to do here
        }
    }
    
    
    func login(_ password: String) {
        if password == "prolific" {
            self.loadDada()
        } else {
            self.showPasswordAlert()
        }
    }

    // Logout detailing
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        
        if(!isUserLoggedIn)
        {
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any)
    {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        
        UserDefaults.standard.synchronize();
        
        self.performSegue(withIdentifier: "loginView", sender: self)
}
}
