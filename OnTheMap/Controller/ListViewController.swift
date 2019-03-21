//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/23/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    // MARK: Properties
    
//    var studentInformation: [Students] = [Students]()
    
    // MARK: Outlets
    
    @IBOutlet weak var studentInformationTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get notificatios on reloading data
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudents()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        
        let cellReuseIdentifier = "StudentInformationCell"
        let studentInfo = StudentsInformation.shared.studentsInformation[(indexPath as NSIndexPath).row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell?.textLabel!.text = studentInfo.studentName
        cell?.detailTextLabel?.text = "\(studentInfo.mediaURL)"
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsInformation.shared.studentsInformation.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("yay")
        didSelectLocation(student: StudentsInformation.shared.studentsInformation[(indexPath as NSIndexPath).row])
    }
    
    private func loadStudents() {
        Client.sharedInstance().getStudents { (information, error) in
            if let information = information {
                StudentsInformation.shared.studentsInformation = information
                performUIUpdatesOnMain {
                    self.studentInformationTableView.reloadData()
                }
            } else {
                print(error ?? "empty error")
            }
        }
    }
    
    func didSelectLocation(student: Students) {
        guard let url = URL(string: student.mediaURL), UIApplication.shared.canOpenURL(url) else {
            print("error")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    @objc func reloadStarted() {
        performUIUpdatesOnMain {
            print("reload for list started")
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.studentInformationTableView.reloadData()
            print("reload for list finished")
        }
    }
}
