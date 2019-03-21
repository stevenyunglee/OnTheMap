//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/24/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import Foundation

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
