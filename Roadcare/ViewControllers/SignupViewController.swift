//
//  SignupViewController.swift
//  Roadcare
//
//  Created by macbook on 4/8/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var tvUserName: UITextField!
    @IBOutlet weak var tvCity: UITextField!
    @IBOutlet weak var tvCountry: UITextField!
    @IBOutlet weak var tvPhone: UITextField!
    @IBOutlet weak var tvEmail: UITextField!
    @IBOutlet weak var tvPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        checkAndRequestRegister()
//        let viewController = SigninViewController(nibName: "SigninViewController", bundle: nil)
//        navigationController!.pushViewController(viewController, animated: true)
    }
    
    private func checkAndRequestRegister() {
        guard let username = tvUserName.text, username.count != 0 else {
            showSimpleAlert(message: "Please input agency name")
            tvUserName.becomeFirstResponder()
            return
        }
        guard let city = tvCity.text, city.count != 0 else {
            showSimpleAlert(message: "Please input city state")
            tvCity.becomeFirstResponder()
            return
        }
        guard let country = tvCountry.text, country.count != 0 else {
            showSimpleAlert(message: "Please input country")
            tvCountry.becomeFirstResponder()
            return
        }
        guard let phone = tvPhone.text, phone.count != 0 else {
            showSimpleAlert(message: "Please input phone number")
            tvPhone.becomeFirstResponder()
            return
        }
        guard let email = tvEmail.text, email.isValidEmail() else {
            showSimpleAlert(message: "Please input valid email")
            tvEmail.becomeFirstResponder()
            return
        }
        guard let password = tvPassword.text, password.count != 0 else {
            showSimpleAlert(message: "Please input password")
            tvPassword.becomeFirstResponder()
            return
        }
        
        tvUserName.resignFirstResponder()
        tvCity.resignFirstResponder()
        
        submitRegister(username: username, city: city, country: country, phone: phone, email: email, password: password)
    }
    
    private func submitRegister(username: String, city: String, country: String, phone: String, email: String, password: String) {
        showProgress(message: "")
        _ = APIClient.register(username: username, email: email, password: password, role: "editor", city: city, country: country, phone: phone, handler: { (success, error, data) in
            
            self.dismissProgress()

            guard success, data != nil, let json = data as? [String: Any] else {
                self.handleError(error: error)
                return
            }
            
            let response = RegisterResponse(json)
            self.showSimpleAlert(message: response.message)

            if response.code == 200 {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    private func handleError(error: String?) {
        showSimpleAlert(message: "Register failed. Please try again")
    }
}
