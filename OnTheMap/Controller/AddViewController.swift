//
//  AddViewController.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/23/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
    }
    
    
}



