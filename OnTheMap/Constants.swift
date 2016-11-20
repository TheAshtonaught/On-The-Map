//
//  Constants.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 10/31/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

struct Constants {
    
    var sessionID: String? = nil

    struct ParseContants {
        static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

    }
    struct UdacityConstants {
        static let AuthUrl = "https://www.udacity.com/api/session"
        
        struct ResponseKeys {
            static let Account = "account"
            static let Session = "session"
        }
    }
}