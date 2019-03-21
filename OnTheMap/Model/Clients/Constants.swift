//
//  Constants.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/23/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

extension Client {

    struct Constants {
        
        static let Parse = "Parse"
        static let Udacity = "Udacity"
        
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let ApiScheme = "https"
        
        static let ParseApiHost = "parse.udacity.com"
        static let ParseApiPath = "/parse/classes"
        
        static let UdacityApiHost = "www.udacity.com"
        static let UdacityApiPath = "/api/session"

    }
    
    struct Methods {
        
        // MARK: Account
        static let StudentLocation = "/StudentLocation"
        static let UpdateStudentLocation = "/StudentLocation/{objectId}"

    }
    
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where  = "where"
    }
    
    struct JSONResponseKeys {
        static let Lat = "latitude"
        static let Long = "longitude"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
    }
    
}
