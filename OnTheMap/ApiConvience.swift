//
//  ApiConvience.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/2/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import Foundation

class ApiConvience {
    
    let session: URLSession!
    let apiConstants: ApiConstants
    
    // initializer that accepts apiConstants
    
    init(apiConstants: ApiConstants) {
      session = URLSession(configuration: URLSessionConfiguration.default)
      self.apiConstants = apiConstants
    }
    // Build Url
    func apiUrlWithMethod(_ method: String?, withPathExtension: String? = nil, parameters: [String:AnyObject]? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = apiConstants.scheme
        components.host = apiConstants.host
        components.path = apiConstants.path + (method ?? "") + (withPathExtension ?? "")
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    // Build Request
    
    func apiRequest(_ url: URL, method: String, headers: [String:String]? = nil, body: [String:AnyObject]?, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if let error = error{
                completionHandler(nil, error)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode < 200 && statusCode > 299 {
                let userInfo = [
                    NSLocalizedDescriptionKey: "Bad Response"
                ]
                let error = NSError(domain: "API", code: statusCode, userInfo: userInfo)
                completionHandler(nil, error)
                return
            }
            completionHandler(data, nil)
        }) 
        task.resume()
    }
        
    
    // Return Errors
    
    func errorReturn(_ code: Int, description: String, domain: String)-> NSError {
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
    
    
}
