//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 10/31/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

extension ParseConvience {
    struct Components {
        static let Scheme = "https"
        static let Host = "parse.udacity.com"
        static let Path = "/parse/classes"
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    struct HeaderKeys {
        static let APIKey = "X-Parse-REST-API-Key"
        static let AppId = "X-Parse-Application-Id"
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    struct HeaderValues {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let JSON = "application/json"
    }
    
    struct ParameterKeys {
        static let Where = "where"
        static let Limit = "limit"
        static let Order = "order"
        static let UniqueKey = "uniqueKey"
    }
    
    struct ParameterValues {
        static let UpdatedAt = "-updatedAt"
        static let CreatedAt = "-createdAt"
    }
    struct BodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }
    struct JSONResponseKeys {
        static let Error = "error"
        static let Results = "results"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }
    
    
    
    
}
