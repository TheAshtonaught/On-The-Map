//
//  TableVC.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/14/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import UIKit

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let udacityClient = UdacityConvience.sharedClient()
    let parseClient = ParseConvience.sharedClient()
    var global = Global.sharedClient()
    var currentStudent: Student? = nil
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateStudentLocations()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return global.studentLocations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! StudentCell
        let location = global.studentLocations[(indexPath as NSIndexPath).row]
        cell.setCell(location)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaUrl = global.studentLocations[(indexPath as NSIndexPath).row]._student.mediaUrl
        
        if let url = URL(string: mediaUrl) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                displayAlert("Error", errorMsg: "Failed to open Link")
            }
        }
    }
    
    

    @IBAction func refreshTable(_ sender: AnyObject) {
        updateStudentLocations()
    }
    @IBAction func addLocation(_ sender: AnyObject) {
        if let currentStudent = global.currentStudent {
            parseClient.studentLocation(currentStudent.uniqueKey, completionHandler: { (location, error) in
                DispatchQueue.main.async {
                    if let loc = location {
                        self.overwriteAlert { (alert) in
                            self.presentAddLocationVC(location?._objectID)
                        }
                    } else {
                        self.presentAddLocationVC()
                    }
                }
            })
        }
    }

    @IBAction func logout(_ sender: AnyObject) {
        udacityClient.logout { (success, error) in
            DispatchQueue.main.async {
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func updateStudentLocations() {
        parseClient.getStudentLocations { (locations, error) in
            
            if let error = error {
                self.displayAlert("Failed to get student locations", errorMsg: error.localizedDescription)
            } else {
                self.global.studentLocations = locations!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func displayAlert(_ errorTitle: String, errorMsg: String) {
        
        let alert = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func overwriteAlert(_ completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Overwrite Location?", message: "Pressing continue would overwrite your last location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler:  completionHandler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAddLocationVC(_ objectID: String? = nil) {
        let addLocVC = self.storyboard!.instantiateViewController(withIdentifier: "addLocationVC") as! addLocationVC
        if let objectID = objectID {
            addLocVC.objectID = objectID
        }
        self.present(addLocVC, animated: true, completion: nil)
    }
    
    func presentLoginVC() {
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginVC, animated: true, completion: nil)
    }
}
