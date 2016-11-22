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
    var global = Global.sharedClient()
    var placemark: CLPlacemark? = nil
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startActivity(loading: false)
    }

    @IBAction func findOnTheMap(_ sender: AnyObject) {
        startActivity(loading: true)
        if locationTextField.text!.isEmpty {
            displayAlert("Location Field empty", errorMsg: "Please enter a location")
            startActivity(loading: false)
            return
        }
        
        DispatchQueue.main.async {
            let geocoder = CLGeocoder()
            do {
                geocoder.geocodeAddressString(self.locationTextField.text!, completionHandler: { (results, error) in
                    if let err = error {
                        self.displayAlert("Error", errorMsg: "Failed to Geocode Location")
                        self.startActivity(loading: false)
                    } else if (results!.isEmpty) {
                        self.displayAlert("Error", errorMsg: "No Location Found")
                        self.startActivity(loading: false)
                    } else {
                        self.placemark = results![0]
                        self.presentAddLinkVC(self.placemark!, mapStr: self.locationTextField.text!, objectID: self.objectID)
                        self.startActivity(loading: false)
                    }
                    
                })
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        navigationController?.dismiss(animated: true, completion: nil)
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
        navigationController?.pushViewController(linkVC, animated: true)
    }
    func startActivity(loading: Bool) {
        if loading {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            locationTextField.alpha = 0.4
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            locationTextField.alpha = 1
        }
    }
    func displayAlert(_ errorTitle: String, errorMsg: String) {
        
        let alert = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
