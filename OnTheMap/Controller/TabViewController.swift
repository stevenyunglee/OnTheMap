//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/25/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    
    

    @IBAction func logoutButtonPressed(_ sender: Any) {
        logoutButton.isEnabled = false
        Client.sharedInstance().logOut() { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                self.logoutButton.isEnabled = true
            } else {
                print(error ?? "logout failed")
                self.logoutButton.isEnabled = true
            }
        }
    }
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        loadStudents()
    }

    @IBAction func addLocationButtonPressed(_ sender: Any) {
        Client.sharedInstance().getStudent() { (data, error) in
            if let error = error {
                print(error ?? "error")
            }
            if let data = data {
                print("You've already posted a location. Would you like to overwrite it?")
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddViewController") as! UIViewController
                self.present(controller, animated: true, completion: nil)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddViewController") as! UIViewController
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func loadStudents() {
        NotificationCenter.default.post(name: .reloadStarted, object: nil)
        Client.sharedInstance().getStudents() { (data, error) in
            if let data = data {
                StudentsInformation.shared.studentsInformation = data
                print("data loaded")
            } else {
                print(error ?? "empty error")
            }
            NotificationCenter.default.post(name: .reloadCompleted, object: nil)
        }
    }
}
