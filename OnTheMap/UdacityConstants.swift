//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/3/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

extension UdacityConvience {
   
    struct Components {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
        static let Path = "/api"
    }
    
    struct Methods {
        static let Session = "/session"
        static let Users = "/users"
    }
    struct Headers {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let JSON = "application/json"
    }
    
    struct HTTPBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }

    struct JSONResponseKeys {
        static let Account = "account"
        static let UserKey = "key"
        static let Status = "status"
        static let Session = "session"
        static let Error = "error"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }

    
}
