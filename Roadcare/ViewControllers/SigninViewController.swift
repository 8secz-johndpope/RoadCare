//
//  SigninViewController.swift
//  Roadcare
//
//  Created by macbook on 4/8/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signinBtnTapped(_ sender: SimpleButton) {
        guard let email = tfEmail.text, email.isValidEmail() else {
            showSimpleAlert(message: "Please input valid email")
            tfEmail.becomeFirstResponder()
            return
        }
        guard let password = tfPassword.text, password.count != 0 else {
            showSimpleAlert(message: "Please input password")
            tfPassword.becomeFirstResponder()
            return
        }
        
        getNonce(email: email, password: password)
    }
    
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        let viewcontroller = SignupViewController(nibName: "SignupViewController", bundle: nil)
        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    private func getNonce(email: String, password: String) {
        showProgress(message: "")
        _ = APIClient.getNonce(handler: { (success, error, data) in
            guard success, data != nil, let json = data as? [String: Any] else {
                self.dismissProgress()
                self.showSimpleAlert(message: "Login failed. Please try again")
                return
            }
            
            let response = AuthNonce(json)
            if response.status == "ok" {
                self.submitLogin(nonce: response.nonce, email: email, password: password)
            }
        })
    }
    
    private func submitLogin(nonce: String, email: String, password: String) {
        _ = APIClient.login(nonce: nonce, username: email, password: password, handler: { (success, error, data) in
            self.dismissProgress()

            guard success, data != nil, let json = data as? [String: Any] else {
                self.showSimpleAlert(message: "Login failed. Please try again")
                return
            }
            
            let response = LoginResponse(json)
            if response.status == "ok" {
                let user = AppUser(response.user)
                user.email = email
                user.password = password
                user.saveToStorage()
                AppConstants.authUser = user
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showSimpleAlert(message: response.error)
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
