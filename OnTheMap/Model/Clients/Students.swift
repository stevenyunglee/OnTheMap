//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Lee, Steve on 11/1/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

struct Students {

    let lat: Double
    let long: Double
    let firstName: String
    let lastName: String
    let mediaURL: String
    
    // MARK: Initializers
    
    // construct a StudentLocations from a dictionary
    init(dictionary: [String:AnyObject]) {
        lat = dictionary[Client.JSONResponseKeys.Lat] as? Double ?? 0.0
        long = dictionary[Client.JSONResponseKeys.Long] as? Double ?? 0.0
        firstName = dictionary[Client.JSONResponseKeys.FirstName] as? String ?? ""
        lastName = dictionary[Client.JSONResponseKeys.LastName] as? String ?? ""
        mediaURL = dictionary[Client.JSONResponseKeys.MediaURL] as? String ?? ""
    }
    
    var studentName: String {
        var name = ""
        if !firstName.isEmpty {
            name = firstName
        }
        if !lastName.isEmpty {
            if name.isEmpty {
                name = lastName
            }
        } else {
            name += "\(lastName)"
        }
        if name.isEmpty {
            return "No name provided"
        }
        return name
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [Students] {
        
        var locations = [Students]()
        
        // iterate through array of dictionaries, each Studeents is a dictionary
        for result in results {
            locations.append(Students(dictionary: result))
            print("Added")
            
        }
        
        return locations
    }
}
