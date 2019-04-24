//
//  PotholeDetailsViewController.swift
//  Roadcare
//
//  Created by macbook on 4/10/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class PotholeDetailsViewController: UIViewController {

    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblReportName: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    @IBOutlet weak var lblDateTime: UITextField!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Potholes Reported in Nablus, Palestine"
    }
    
    @IBAction func fixPothole(_ sender: SimpleButton) {
    }
    
    @IBAction func listenComplaint(_ sender: SimpleButton) {
    }
}
