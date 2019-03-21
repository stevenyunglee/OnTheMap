//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/23/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Login

    @IBAction func loginPressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugLabel.text = "Username or Password Empty."
        } else {
            setUIEnabled(false)
            Client.sharedInstance().logIn(emailTextField.text!, password: passwordTextField.text!) { (data, error) in
                if let error = error {
                    print(error)
                    self.setUIEnabled(true)
                } else {
                    self.completeLogin()
                    self.setUIEnabled(true)
                }
            }
        }
    }

    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - LoginViewController (Configure UI)

private extension LogInViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        logInButton.isEnabled = enabled
        debugLabel.text = ""
        debugLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            logInButton.alpha = 1.0
        } else {
            logInButton.alpha = 0.5
        }
    }
}
