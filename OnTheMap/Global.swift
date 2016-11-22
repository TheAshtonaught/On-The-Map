//
//  Global.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/22/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

class Global {
    var currentStudent: Student? = nil
    var studentLocations = [StudentLocation]()
    
    static var sharedInstance = Global()
    class func sharedClient() -> Global {
        return sharedInstance
    }
}
