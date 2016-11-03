//
//  RegisterPageViewController.swift
//  projectNYiT
//
//  Created by Soji Balogun on 10/30/16.
//  Copyright © 2016 Soji Balogun. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text;
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: userEmail!)
        
        if isEmailAddressValid
        {
            print("email address is valid")
        }
        else {
            print("email address is not valid")
            displayMyAlertMessage(userMessage: "email address is not valid")
        }
        
        let userPassword = userPasswordTextField.text;
        let userVerifyPassword = verifyPasswordTextField.text;
        
        // Check for empty fields
        if (userEmail!.isEmpty) || (userPassword!.isEmpty) || (userVerifyPassword!.isEmpty)
        {
            // Display alert message
            
            displayMyAlertMessage(userMessage: "All fields are required");
            
            return;
        }
        
        // Check if password matches
        if (userPassword != userVerifyPassword)
        {
            // Display alert message
            
            displayMyAlertMessage(userMessage: "Passwords do not match");
            
            return;
        }
        
        // Store Data in Database (Servers)
        
        UserDefaults.standard.set(userEmail, forKey: "userEmail")
        
        UserDefaults.standard.set(userPassword, forKey: "userPassword")
        
        UserDefaults.standard.synchronize();
        
        // Display alert message with confirmation
        
        let myAlert = UIAlertController(title: "Alert", message: "Registeration is completed. Thank You!", preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){action in self.dismiss(animated: true, completion: nil);
            
        }
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }

    func displayMyAlertMessage(userMessage:String)
    {
        
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
        
    }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func displayAlertMessage(MessageToDisplay:String)
        
    {
    let alertController = UIAlertController(title: "Alert title", message: MessageToDisplay, preferredStyle: .alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        
        // Code in this block will trigger when OK button tapped.
        print("Ok button tapped");
        
    }
        
    alertController.addAction(OKAction)
    
    self.present(alertController, animated: true, completion:nil)
    
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
