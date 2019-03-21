//
//  Convenience.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/23/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import UIKit
import Foundation

extension Client {
    
    func logIn(_ email: String, password: String, completionHandlerForLogIn: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        
        /* Set the parameters here */
        
        let parameters = [String:AnyObject]()
        
        let jsonbody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        /* Create the URL here. Parse or Udacity API */

        let url = udacityURLFromParameters(parameters)
        
        let _ = taskForPOSTMethod(url, jsonBody: jsonbody, apiName: Client.Constants.Udacity) { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLogIn(nil, error)
            } else {
                if let sessionDictionary = results?["session"] as? [String:AnyObject], let accountDictionary = results?["account"] as? [String:AnyObject] {
                    let sessionID = sessionDictionary["id"] as? String
                    let accountKey = accountDictionary["key"] as? String
                    completionHandlerForLogIn(sessionID, nil)
                    self.sessionID = sessionID
                    self.accountKey = accountKey!
                    print(self.sessionID)
                    print(self.accountKey)
                } else {
                    completionHandlerForLogIn(nil, NSError(domain: "Log In parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse"]))
                }
            }
        }
    }
    
    func getStudents (_ completionHandlerForStudents: @escaping (_ result: [Students]?, _ error: NSError?) -> Void) {
        
        let parameters = [Client.ParameterKeys.Limit: "100", Client.ParameterKeys.Order: "updatedAt"] as [String:AnyObject]
        
        var url = parseURLFromParameters(parameters, withPathExtension: Methods.StudentLocation)
        url.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        url.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let _ = taskForGETMethod(url, apiName: Client.Constants.Parse) { (results, error) in
            
            if let error = error {
                completionHandlerForStudents(nil, error)
            } else {
                if let locationsDictionary = results?["results"] as? [[String : AnyObject]] {
                    let locations = Students.studentsFromResults(locationsDictionary)
                    completionHandlerForStudents(locations, nil)
                } else {
                    completionHandlerForStudents(nil, NSError(domain: "Students location parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse"]))
                }
            }
        }
    }
    
    func getStudent (_ completionHandlerForStudent: @escaping (_ result: Students?, _ error: NSError?) -> Void) {
        
        let parameters = [Client.ParameterKeys.Where: "{\"uniqueKey\":\"\(self.accountKey)\"}"] as [String:AnyObject]
        
        var url = parseURLFromParameters(parameters, withPathExtension: Methods.StudentLocation)
        url.addValue(Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        url.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let _ = taskForGETMethod(url, apiName: Client.Constants.Parse) { (results, error) in
            if let error = error {
                completionHandlerForStudent(nil, error)
            } else {
                if let locationDictionary = results?["results"] as? [[String : AnyObject]] {
                    if let studentInformation = locationDictionary.first {
                        completionHandlerForStudent(Students(dictionary: studentInformation), nil)
                    }
                } else {
                    completionHandlerForStudent(nil, NSError(domain: "Student location parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse"]))
                }
            }
        }
    }
    
    func logOut (_ completionHandlerForLogOut: @escaping (_ success: Bool, _ Error: NSError?) -> Void) {
        
        print("logOut")
        let parameters = [String:AnyObject]()
        var url = udacityURLFromParameters(parameters)
        
        let _ = taskForDELETEMethod(url, apiName: Client.Constants.Udacity) { (results, error) in
            
            if let error = error {
                completionHandlerForLogOut(false, error)
            } else {
                completionHandlerForLogOut(true, nil)
                print("logout successful")
                self.sessionID = ""
            }
        }
    }
}
