//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 10/26/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    let udacityClient = UdacityConvience.sharedClient()
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(active: true)
    }


    @IBAction func signUpBtnPress(_ sender: AnyObject) {
        if let signUpURL = URL(string: "https://www.udacity.com/account/auth#!/signup") {
        UIApplication.shared.openURL(signUpURL)
        }
    }
    
    
    @IBAction func LoginBtnPressed(_ sender: AnyObject) {
        configureUI(active: false)
        
        if emailLabel.text!.isEmpty || passwordLabel.text!.isEmpty{
           displayError("Login Error", errorMsg: "Missing a Username/password")
        } else {
            udacityClient.LoginToUdacity(emailLabel.text!, password: passwordLabel.text!, completionHandler: { (userKey, error) in
                DispatchQueue.main.async {
                    if let userKey = userKey {
                        self.udacityClient.getStudent(userKey, completionHandler: { (student, error) in
                            DispatchQueue.main.async {
                                if let student = student {
                                    self.appDelegate.currentStudent = student
                                    self.performSegue(withIdentifier: "login", sender: self)
                                } else {
                                    self.displayError("Login error", errorMsg: error!.localizedDescription)
                                }
                            }
                        })
                    } else {
                        self.displayError("login error", errorMsg: error!.localizedDescription)
                    }
                }
            })
        }
        
        
    }
    
    func configureUI(active: Bool) {
        
        emailLabel.isHidden = !active
        passwordLabel.isHidden = !active
        signUpBtn.isHidden = !active
        loginBtn.isEnabled = active
        signUpBtn.isHidden = !active
            
        activityIndicator.isHidden = active
        
        if !active {
            loginBtn.alpha = 0.4
            activityIndicator.startAnimating()
        } else {
            loginBtn.alpha = 1.0
            activityIndicator.stopAnimating()
        }
    }
    
    func displayError(_ errorTitle: String, errorMsg: String) {
        configureUI(active: true)
        let alert = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
