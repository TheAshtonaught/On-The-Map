//
//  addLocationVC.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/14/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import UIKit
import MapKit

class addLocationVC: UIViewController, UITextFieldDelegate {

    var objectID: String? = nil
    let parseClient = ParseConvience.sharedClient()
    var appDel: AppDelegate!
    var placemark: CLPlacemark? = nil
    
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDel = UIApplication.shared.delegate as! AppDelegate
    }

    @IBAction func findOnTheMap(_ sender: AnyObject) {
        if locationTextField.text!.isEmpty {
            displayAlert("Location Field empty", errorMsg: "Please enter a location")
            return
        }
        
        DispatchQueue.main.async {
            let geocoder = CLGeocoder()
            do {
                geocoder.geocodeAddressString(self.locationTextField.text!, completionHandler: { (results, error) in
                    if let err = error {
                        self.displayAlert("Error", errorMsg: "Failed to Geocode Location")
                    } else if (results!.isEmpty) {
                        self.displayAlert("Error", errorMsg: "No Location Found")
                    } else {
                        self.placemark = results![0]
                        self.presentAddLinkVC(self.placemark!, mapStr: self.locationTextField.text!, objectID: self.objectID)
                    }
                    
                })
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func presentAddLinkVC(_ placemark: CLPlacemark, mapStr: String, objectID: String? = nil) {
        let linkVC = self.storyboard!.instantiateViewController(withIdentifier: "addLinkVC") as! addLinkVC
        linkVC.placemark = placemark
        linkVC.mapString = mapStr
        if let id = objectID {
            linkVC.objectID = id
        }
        self.present(linkVC, animated: true, completion: nil)
    }
    
    func displayAlert(_ errorTitle: String, errorMsg: String) {
        
        let alert = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
