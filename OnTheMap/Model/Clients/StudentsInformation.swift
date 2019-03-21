//
//  StudentsInformation.swift
//  OnTheMap
//
//  Created by Lee, Steve on 11/11/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import Foundation

struct StudentsInformation {
    
    static var shared = StudentsInformation()
    
    private init() {}
    
    var studentsInformation = [Students]()
    
}
