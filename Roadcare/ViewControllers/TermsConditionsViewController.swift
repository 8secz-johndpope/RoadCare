//
//  TermsConditionsViewController.swift
//  Roadcare
//
//  Created by macbook on 4/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class TermsConditionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        navigationItem.title = "Contact Us"
    }
    
    @IBAction func agreeTapped(_ sender: SimpleButton) {
        self.showDashboard()
    }
    
    @IBAction func disagreeTapped(_ sender: SimpleButton) {
        self.dismiss(animated: true
            , completion: nil)
    }
    
    @IBAction func continueBtnTapped(_ sender: SimpleButton) {
        self.showDashboard()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true
            , completion: nil)
    }
    
    private func showDashboard() {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        appDelegate.showDashboard()
    }
}
