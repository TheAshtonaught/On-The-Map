//
//  annotationStyle.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/14/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation
import MapKit

extension MapVC {
    @objc(mapView:viewForAnnotation:) func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pinID"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
