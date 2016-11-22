//
//  ParseConvience.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/6/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

class ParseConvience {
    
    let apiConvience: ApiConvience
    
    init() {
        let apiConstants = ApiConstants(scheme: Components.Scheme, host: Components.Host, path: Components.Path, domain: "ParseClient")
        apiConvience = ApiConvience(apiConstants: apiConstants)
    }
    
    fileprivate static var sharedInstance = ParseConvience()
    class func sharedClient() -> ParseConvience {
        return sharedInstance
    }
    
    fileprivate func parseApiRequest(url: URL, method: String, body: [String:AnyObject]? = nil, completionHandler: @escaping (_ jsonAsDictionary: [String:AnyObject]?, _ error: NSError?) -> Void) {
        
        let headers = [
            HeaderKeys.AppId:HeaderValues.AppId,
            HeaderKeys.APIKey:HeaderValues.APIKey,
            HeaderKeys.Accept:HeaderValues.JSON,
            HeaderKeys.ContentType: HeaderValues.JSON
        ]
        
        apiConvience.apiRequest(url, method: method, headers: headers, body: body) { (data, error) in
            if let data = data {
                let JsonAsDict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                completionHandler(JsonAsDict, nil)
             } else {
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func getStudentLocations(_ completionHandler: @escaping (_ locations: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        let urlForlocation = apiConvience.apiUrlWithMethod(Methods.StudentLocation, parameters: [ParameterKeys.Limit: 100 as AnyObject,
            ParameterKeys.Order: ParameterValues.UpdatedAt as AnyObject])
        parseApiRequest(url: urlForlocation, method: "GET") { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let jsonDict = jsonAsDictionary, let studentDicts = jsonDict[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                
                completionHandler(StudentLocation.locFromDict(studentDicts), nil)
                return
            }
            
            completionHandler(nil, self.apiConvience.errorReturn(0, description: "No Student locations found", domain: "Parse Client"))
        }
    }
    
    func studentLocation(_ userKey: String, completionHandler: @escaping (_ location: StudentLocation?, _ error: NSError?) -> Void) {
        
        let locationUrl = apiConvience.apiUrlWithMethod(Methods.StudentLocation,  parameters: [ParameterKeys.Where: ("{\"\(ParameterKeys.UniqueKey)\":\"" + "\(userKey)" + "\"}") as AnyObject
        ])
        
        parseApiRequest(url: locationUrl, method: "GET") { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let jsonDict = jsonAsDictionary, let studentDict = jsonDict[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                
                if studentDict.count == 1 {
                    completionHandler(StudentLocation(locationDict: studentDict[0]), nil)
                    return
                }
            }
            
            completionHandler(nil, self.apiConvience.errorReturn(0, description: "Could not get Student Location", domain: "Parse Client"))
        }
    }
    
    func postLocation(_ studentLocation: StudentLocation, mediaUrl: String, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let locationUrl = apiConvience.apiUrlWithMethod(Methods.StudentLocation)
        let body: [String:AnyObject] = [BodyKeys.UniqueKey: studentLocation._student.uniqueKey as AnyObject,
            BodyKeys.FirstName: studentLocation._student.firstName as AnyObject,
            BodyKeys.LastName: studentLocation._student.lastName as AnyObject,
            BodyKeys.MapString: studentLocation._location.mapString as AnyObject,
            BodyKeys.MediaURL: mediaUrl as AnyObject,
            BodyKeys.Latitude: studentLocation._location.latitude as AnyObject,
            BodyKeys.Longitude: studentLocation._location.longitude as AnyObject
        ]
        
        parseApiRequest(url: locationUrl, method: "POST", body: body) { (jsonAsDictionary, error) in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            
            if let jsonDict = jsonAsDictionary, let objectId = jsonDict[JSONResponseKeys.ObjectID] as? String {
                completionHandler(true, nil)
                return
            }
            
            if let jsonDict = jsonAsDictionary, let error = jsonDict[JSONResponseKeys.Error] as? String {
                completionHandler(true, self.apiConvience.errorReturn(0, description: error, domain: "Parse Client"))
                return
            }
            
            completionHandler(false, self.apiConvience.errorReturn(0, description: "Could Not Post Location", domain: "Parse Client"))
        }
    }
    
    func overwriteLocation(_ ID: String, mediaUrl: String, studentLocation: StudentLocation, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let locationUrl = apiConvience.apiUrlWithMethod(Methods.StudentLocation, withPathExtension: "/\(ID)")
        let body: [String:AnyObject] = [BodyKeys.UniqueKey: studentLocation._student.uniqueKey as AnyObject,
            BodyKeys.FirstName: studentLocation._student.firstName as AnyObject,
            BodyKeys.LastName: studentLocation._student.lastName as AnyObject,
            BodyKeys.MapString: studentLocation._location.mapString as AnyObject,
            BodyKeys.MediaURL: mediaUrl as AnyObject,
            BodyKeys.Latitude: studentLocation._location.latitude as AnyObject,
            BodyKeys.Longitude: studentLocation._location.longitude as AnyObject
        ]
        
        parseApiRequest(url: locationUrl, method: "PUT", body: body) { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            
            if let jsonDict = jsonAsDictionary, let updated = jsonDict[JSONResponseKeys.UpdatedAt] {
                completionHandler(true, nil)
                return
            }
            
            if let jsonDict = jsonAsDictionary, let error = jsonDict[JSONResponseKeys.Error] as? String {
                completionHandler(true, self.apiConvience.errorReturn(0, description: error, domain: "Parse Client"))
                return
            }
            
            completionHandler(false, self.apiConvience.errorReturn(0, description: "Could Not Update Locaiton", domain: "Parse Client"))
        }
    }
    
}
