//
//  Student.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/6/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

struct Student {
    let firstName: String
    let lastName: String
    let uniqueKey: String
    var mediaUrl: String
    
    init(uniqueKey: String, firstName: String, lastName: String, mediaURL: String) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mediaUrl = mediaURL
    }
    // initialize with unique key
    
    init(uniqueKey: String) {
        self.uniqueKey = uniqueKey
        firstName = ""
        lastName = ""
        mediaUrl = ""
    }
}



