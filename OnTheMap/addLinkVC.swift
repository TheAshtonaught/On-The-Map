//
//  addLinkVC.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/14/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import UIKit
import MapKit

class addLinkVC: UIViewController, UITextFieldDelegate{
    
    var placemark: CLPlacemark!
    var appDel: AppDelegate!
    var mapString: String!
    var objectID: String? = nil
    let parseClient = ParseConvience.sharedClient()

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locationMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = UIApplication.shared.delegate as! AppDelegate
        locationMapView.showAnnotations([MKPlacemark(placemark: placemark)], animated: true)
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if linkTextField.text!.isEmpty {
            displayAlert("No Link", errorMsg: "Please add a link")
            return
        }
        
        guard let newLocation = placemark.location else {
            displayAlert("Error", errorMsg: "Placemark Not Found")
            return
        }
        
        let location = Location(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, mapString: mapString)
        
        let url = linkTextField.text!
        
        if let objectID = objectID {
            parseClient.overwriteLocation(objectID, mediaUrl: url, studentLocation: StudentLocation(objectId: objectID, student: appDel.currentStudent!, location: location))  { (success, error) in
                DispatchQueue.main.async {
                if let _ = error {
                    self.displayAlert("Error", errorMsg: "Could Not post location")
                } else {
                    self.appDel.currentStudent?.mediaUrl = url
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            parseClient.postLocation(StudentLocation(objectId: "", student: appDel.currentStudent!, location: location), mediaUrl: url, completionHandler: { (success, error) in
                DispatchQueue.main.async{
                if let _ = error {
                    self.displayAlert("Error", errorMsg: "Could Not post location")
                } else {
                    self.appDel.currentStudent?.mediaUrl = url
                    self.presentTabBar()
                }
                }
            })
        }
        
    }

    func displayAlert(_ errorTitle: String, errorMsg: String) {
        
        let alert = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func presentTabBar() {
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
}
