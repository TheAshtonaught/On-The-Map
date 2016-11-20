//
//  Location.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/6/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation
import MapKit

struct Location {
    let latitude: Double
    let longitude: Double
    let mapString: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
