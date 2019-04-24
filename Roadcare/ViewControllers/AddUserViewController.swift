//
//  AddUserViewController.swift
//  Roadcare
//
//  Created by macbook on 4/8/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var addUserView: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.firstView.isHidden = false
        self.addUserView.isHidden = true
    }
    
    @IBAction func addUserBtnTapped(_ sender: SimpleButton) {
        self.firstView.isHidden = true
        self.addUserView.isHidden = false
    }
    
    @IBAction func dontBtnTapped(_ sender: SimpleButton) {
        guard let email = tfEmail.text, email.isValidEmail() else {
            showSimpleAlert(message: "Please input valid email")
            return
        }
        guard let password = tfPassword.text, password.count != 0 else {
            showSimpleAlert(message: "Please input password")
            return
        }
        
        submitAddUser(email: email, password: password)
    }
    
    @IBAction func addNewUser(_ sender: SimpleButton) {
        tfEmail.text = ""
        tfPassword.text = ""
    }
    
    private func submitAddUser(email: String, password: String) {
        showProgress(message: "")

        let username = AppUser.getSavedUser().username! + "_" +  DateUtils.getTimeStamp()
        _ = APIClient.addUser(username: username, email: email, password: password, handler: { (success, error, data) in
            self.dismissProgress()
            
            guard success, data != nil, let json = data as? [String: Any] else {
                self.showSimpleAlert(message: "Register failed. Please try again")
                return
            }
            
            let response = RegisterResponse(json)
            
            if response.code == 200 {
                self.showSimpleAlert(message: "Added a new user successful!")
                self.tfEmail.text = ""
                self.tfPassword.text = ""
                self.firstView.isHidden = false
                self.addUserView.isHidden = true
            } else {
                self.showSimpleAlert(message: response.message)
            }
        })
    }
}
