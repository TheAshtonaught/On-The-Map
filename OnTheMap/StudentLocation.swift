//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/7/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    let _objectID: String
    let _student: Student
    let _location: Location
    let notAvailable = "N/A"
    
    init(objectId: String, student: Student, location: Location) {
        _objectID = objectId
        _student = student
        _location = location
    }
    
    // initialize with Location Dictionary
    
    init(locationDict: [String:AnyObject]) {
        
        let _firstName: String
        let _LastName: String
        let _mediaUrl: String
        let _uniqueKey: String
        let _latitude: Double
        let _longitude: Double
        let _mapString: String
        
        if let objectID = locationDict[ParseConvience.JSONResponseKeys.ObjectID] as? String {
            _objectID = objectID
        } else {
            _objectID = ""
        }
        
        if let first = locationDict[ParseConvience.JSONResponseKeys.FirstName] as? String {
            _firstName = first
        } else {
            _firstName = notAvailable
        }
        
        if let last = locationDict[ParseConvience.JSONResponseKeys.LastName] as? String {
            _LastName = last
        } else {
            _LastName = notAvailable
        }
        
        if let url = locationDict[ParseConvience.JSONResponseKeys.MediaURL] as? String {
            _mediaUrl = url
        } else {
            _mediaUrl = notAvailable
        }
        
        if let uK = locationDict[ParseConvience.JSONResponseKeys.UniqueKey] as? String {
            _uniqueKey = uK
        } else {
            _uniqueKey = notAvailable
        }
        
        if let lat = locationDict[ParseConvience.JSONResponseKeys.Latitude] as? Double {
            _latitude = lat
        } else {
            _latitude = 0.0
        }
        
        if let lon = locationDict[ParseConvience.JSONResponseKeys.Longitude] as? Double {
            _longitude = lon
        } else {
            _longitude = 0.0
        }
        
        if let mapStr = locationDict[ParseConvience.JSONResponseKeys.MapString] as? String {
            _mapString = mapStr
        } else {
           _mapString = notAvailable
        }
        
        _student = Student(uniqueKey: _uniqueKey, firstName: _firstName, lastName: _LastName, mediaURL: _mediaUrl)
        
        _location = Location(latitude: _latitude, longitude: _longitude, mapString: _mapString)
    }
    
    // initialize without objectId
    
    init(student: Student, location: Location) {
        _objectID = ""
        _student = student
        _location = location
    }
    
    
    // MARK: Helper function to get location from dictionary
    
    static func locFromDict(_ dictionaryArr: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocs = [StudentLocation]()
        for studentDict in dictionaryArr {
            studentLocs.append(StudentLocation(locationDict: studentDict))
        }
        return studentLocs
    }
}



















