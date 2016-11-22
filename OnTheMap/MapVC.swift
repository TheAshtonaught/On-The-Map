//
//  MapVC.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/10/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    let udacityClient = UdacityConvience.sharedClient()
    let parseClient = ParseConvience.sharedClient()
    var appDel: AppDelegate!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDel = UIApplication.shared.delegate as! AppDelegate
        updateStudentLocations()
    }
    
    
    @IBAction func addLocation(_ sender: AnyObject) {
        if let currentStudent = appDel.currentStudent {
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

    @IBAction func refreshBtnPressed(_ sender: AnyObject) {
        updateStudentLocations()
    }
    
    @IBAction func logout(_ sender: AnyObject) {
      udacityClient.logout { (success, error) in
        DispatchQueue.main.async {
            self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func addAnnotations() {
        var annotationArray = [MKPointAnnotation]()
        
        for location in appDel.studentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location._location.coordinate
            annotation.title = "\(location._student.firstName) \(location._student.lastName)"
            annotation.subtitle = location._student.mediaUrl
            annotationArray.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotationArray)
        }
        
    }
    
    func updateStudentLocations() {
        parseClient.getStudentLocations { (locations, error) in
            
            if let error = error {
                self.displayAlert("Failed to get student locations", errorMsg: error.localizedDescription)
            } else {
                self.appDel.studentLocations = locations!
                DispatchQueue.main.async {
                    self.addAnnotations()
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                } else {
                    displayAlert("Error", errorMsg: "Can not open Link")
                }
                
            }
        }
    }

    func presentAddLocationVC(_ objectID: String? = nil) {
        let addLocVC = self.storyboard!.instantiateViewController(withIdentifier: "addLocationVC") as! addLocationVC
        if let objectID = objectID {
            addLocVC.objectID = objectID
        }
        let navController = UINavigationController(rootViewController: addLocVC)
        present(navController, animated:true, completion: nil)
    }

}
