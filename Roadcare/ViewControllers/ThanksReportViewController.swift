//
//  ThanksReportViewController.swift
//  Roadcare
//
//  Created by macbook on 4/17/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class ThanksReportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func reportAnotherTapped(_ sender: SimpleButton) {
        self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("report_again"), object: nil)
    }
}
