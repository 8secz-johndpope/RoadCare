//
//  ReportPotholeViewController.swift
//  Roadcare
//
//  Created by macbook on 4/10/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class ReportPotholeViewController: UIViewController {

    @IBOutlet weak var tfStreedName: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfNearby: UITextField!
    @IBOutlet weak var tfReporterName: UITextField!
    @IBOutlet weak var tfPhoneNum: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Report a Pothole"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tfStreedName.text = ""
        tfCity.text = ""
        tfNearby.text = ""
        tfReporterName.text = ""
        tfPhoneNum.text = ""
        topConstraint.constant = 30
    }
    @IBAction func topEditingBegin(_ sender: Any) {
        topConstraint.constant = 30
    }
    
    @IBAction func nearbyEditingBegin(_ sender: Any) {
        topConstraint.constant = -50
    }
    
    @IBAction func reporterEditingBegin(_ sender: Any) {
        topConstraint.constant = -150
    }
    
    @IBAction func phoneEditingBegin(_ sender: Any) {
        topConstraint.constant = -230
    }
    
    @IBAction func nextButtonTapped(_ sender: SimpleButton) {
        guard let streetName = tfStreedName.text, streetName.count != 0 else {
            showSimpleAlert(message: "Please input street name")
            return
        }
        guard let city = tfCity.text, city.count != 0 else {
            showSimpleAlert(message: "Please input city")
            return
        }
        guard let nearby = tfNearby.text, nearby.count != 0 else {
            showSimpleAlert(message: "Please input nearby places")
            return
        }
        guard let reporterName = tfReporterName.text, reporterName.count != 0 else {
            showSimpleAlert(message: "Please input reporter name")
            return
        }
        guard let phoneNum = tfPhoneNum.text, phoneNum.count != 0 else {
            showSimpleAlert(message: "Please input phone number")
            return
        }

        tfStreedName.resignFirstResponder()
        tfCity.resignFirstResponder()
        tfNearby.resignFirstResponder()
        tfReporterName.resignFirstResponder()
        tfPhoneNum.resignFirstResponder()
        
        showProgress(message: "")

        let details = PotholeDetails();
        details.title = streetName + " ," + city
        details.status = "publish"
        
        let metaBox = MetaBox()
        metaBox.street_name = streetName
        metaBox.city = city
        metaBox.reporter_name = reporterName
        metaBox.phone_number = phoneNum
        metaBox.nearby_places = nearby
        metaBox.reported_number = "1"
        
        details.metaBox = metaBox
        
        _ = APIClient.reportPothole(params: details, handler: { (success, error, data) in
            self.dismissProgress()
            guard success, data != nil, let json = data as? [String: Any] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }

            let response = PotholeDetails(json)
            
            if response.id == nil {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            } else {
                let viewController = MappingPotholesViewController(nibName: "MappingPotholesViewController", bundle: nil)
                viewController.id = response.id
                self.navigationController!.pushViewController(viewController, animated: true)
            }
        })
    }
}
