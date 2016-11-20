
//
//  UdacityConvience.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/3/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

class UdacityConvience {
    
    let apiConvience: ApiConvience
    
    init() {
        let apiConstants = ApiConstants(scheme: Components.Scheme, host: Components.Host, path: Components.Path, domain: "UdacityClient")
        apiConvience = ApiConvience(apiConstants: apiConstants)
    }
    
    fileprivate static var sharedInstance = UdacityConvience()
    
    class func sharedClient() -> UdacityConvience {
        return sharedInstance
    }
    
    func udacityApiRequest(url: URL, method: String, body: [String:Any]? = nil, headers: [String:String]? = nil, completionHandler: @escaping (_ jsonAsDictionary: [String:AnyObject]?, _ error: NSError?) -> Void) {
    
        var _headers = [Headers.Accept: Headers.JSON, Headers.ContentType: Headers.JSON]
        if let headers = headers {
            for (key, value) in headers {
                _headers[key] = value
            }
        }
        
        apiConvience.apiRequest(url, method: method, headers: _headers, body: body as [String : AnyObject]?) { (data, error) in
            if let data = data {
                let jsonAsDict = try! JSONSerialization.jsonObject(with: data.subdata(in: 5..<(data.count)), options: .allowFragments) as! [String:AnyObject]
                completionHandler(jsonAsDict, nil)
            }
        }
        
    }
    
    func LoginToUdacity(_ username: String, password: String, completionHandler: @escaping (_ userKey: String?, _ error: NSError?) -> Void) {
        
        let loginUrl = apiConvience.apiUrlWithMethod(Methods.Session)
        var loginBody = [String:Any]()
        loginBody[HTTPBodyKeys.Udacity] = [
            HTTPBodyKeys.Username: username,
            HTTPBodyKeys.Password: password
        ]
        
        udacityApiRequest(url: loginUrl, method: "POST", body: loginBody) { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let jsonAsDict = jsonAsDictionary {
                if let status = jsonAsDict[JSONResponseKeys.Status] as? Int, let error = jsonAsDict[JSONResponseKeys.Error] as? String {
                    completionHandler(nil, self.apiConvience.errorReturn(status, description: error, domain: "UdacityClient"))
                    return
                }
                
                if let account = jsonAsDict[JSONResponseKeys.Account] as? [String:AnyObject], let key = account[JSONResponseKeys.UserKey] as? String {
                    completionHandler(key, nil)
                    return
                }
            }
            // catch any other error
            completionHandler(nil, self.apiConvience.errorReturn(0, description: "login failed", domain: "UdacityClient"))
        }
    }
    

    func getStudent(_ userKey: String, completionHandler: @escaping (_ student: Student?, _ error: NSError?) -> Void) {
        
        let userMethodURL = apiConvience.apiUrlWithMethod(Methods.Users, withPathExtension: "/\(userKey)")
        
        udacityApiRequest(url: userMethodURL, method: "GET") { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let jsonDict = jsonAsDictionary,
                 let userDict = jsonDict[JSONResponseKeys.User] as? [String:AnyObject],
                let first = userDict[JSONResponseKeys.FirstName] as? String,
                let last = userDict[JSONResponseKeys.LastName] as? String {
                    completionHandler(Student(uniqueKey: userKey, firstName: first, lastName: last, mediaURL: ""), nil)
                    return
            }
            
            // catch any other errors
            completionHandler(nil, self.apiConvience.errorReturn(0, description: "Failed to get Student Data", domain: "UdacityClient"))
        }
    }
    
    func logout(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let url = apiConvience.apiUrlWithMethod(Methods.Session)
        var headers = [String:String]()
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        udacityApiRequest(url: url, method: "DELETE", headers: headers) { (jsonAsDictionary, error) in
            
            guard error == nil else {
                completion(false, error)
                return
            }
            
            if let jsonDict = jsonAsDictionary, let session = jsonDict[JSONResponseKeys.Session] as? [String:AnyObject] {
                completion(true, nil)
                return
            }
            
            completion(false, self.apiConvience.errorReturn(0, description: "Logout Failed", domain: "Udacity Client"))
        }
    }

}
