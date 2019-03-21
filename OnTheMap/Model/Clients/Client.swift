//
//  Client.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/23/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import Foundation

class Client : NSObject {

    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    var accountKey = ""
    
    var locations = [[String : Any]]()

    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func taskForPOSTMethod(_ url: URLRequest, jsonBody: String, apiName: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        var request = url
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* Make the request */
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if apiName == Client.Constants.Udacity {
                /* Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandlerForUdacity(data, completionHandlerForConvertData: completionHandlerForPOST)
            } else if apiName == Client.Constants.Parse {
                self.convertDataWithCompletionHandlerForParse(data, completionHandlerForConvertData: completionHandlerForPOST)
            }
            
            /* Use the data! */
        }
        
        task.resume()
        
        return task
    }
    
    func taskForGETMethod(_ url: URLRequest, apiName: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        /* 2/3. Build the URL, Configure the request */
        var request = url
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if apiName == Client.Constants.Udacity {
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandlerForUdacity(data, completionHandlerForConvertData: completionHandlerForGET)
            } else if apiName == Client.Constants.Parse {
                self.convertDataWithCompletionHandlerForParse(data, completionHandlerForConvertData: completionHandlerForGET)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForDELETEMethod(_ url: URLRequest, apiName: String, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
     
        var request = url
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if apiName == Client.Constants.Udacity {
                /* Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandlerForUdacity(data, completionHandlerForConvertData: completionHandlerForDELETE)
            } else if apiName == Client.Constants.Parse {
                self.convertDataWithCompletionHandlerForParse(data, completionHandlerForConvertData: completionHandlerForDELETE)
            }
            
            /* Use the data! */
        }
        
        task.resume()
        
        return task

    }

    // given raw JSON, return a usable Foundation object
    
    private func convertDataWithCompletionHandlerForUdacity(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject? = nil
        do {
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // given raw JSON, return a usable Foundation object
    
    private func convertDataWithCompletionHandlerForParse(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject? = nil
        do {
            
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URLRequest {
        
        var components = URLComponents()
        components.scheme = Client.Constants.ApiScheme
        components.host = Client.Constants.UdacityApiHost
        components.path = Client.Constants.UdacityApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return URLRequest(url: components.url!)
    }
    
    func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URLRequest {
        
        var components = URLComponents()
        components.scheme = Client.Constants.ApiScheme
        components.host = Client.Constants.ParseApiHost
        components.path = Client.Constants.ParseApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return URLRequest(url: components.url!)
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
}
