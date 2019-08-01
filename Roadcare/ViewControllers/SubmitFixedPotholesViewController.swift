//
//  SubmitFixedPotholesViewController.swift
//  Roadcare
//
//  Created by macbook on 5/8/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import OneSignal

class SubmitFixedPotholesViewController: UIViewController {

    @IBOutlet weak var ivPothole: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var thanksView: UIView!
    
    var materials: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tfName.text = AppUser.getSavedUser().email
        tfDate.text = DateUtils.convertDateToStr(date: Date(), format: "yyyy-MM-dd")
        thanksView.isHidden = true
        
        if SELECTED_POTHOLE_PHOTO != "" {
            ivPothole.sd_setImage(with: URL(string: SELECTED_POTHOLE_PHOTO),
                                 placeholderImage: UIImage(named: ""))
        }
    }
    
    private func sendNotification() {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let pushToken = status.subscriptionStatus.pushToken
        
        if pushToken != nil {
            let message = "Fixed the reported potholes by \(tfName.text)"
            let notificationContent = [
                "contents": ["en": message],
                "headings": ["en": "Fixed potholes"],
                "included_segments": "Subscribed Users",
                "ios_badgeType": "Increase",
                "ios_badgeCount": 1
                ] as [String : Any]
            
            OneSignal.postNotification(notificationContent)
        }
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        showProgress(message: "")
        
        let metaBox: [String: Any] = [
            "repaired_status": REPAIRED,
            "repaired_name": tfName.text!
        ]
        let params: [String: Any] = [
            "modified": DateUtils.convertDateToStr(date: Date(), format: "yyyy-MM-dd'T'hh:mm:ss"),
            "meta_box": metaBox
        ]
        
        _ = APIClient.updatePotholePhoto(id: POTHOLE_ID, params: params, handler: { (success, error, data) in
            self.dismissProgress()
            
            guard success, data != nil, let _ = data as? [String: Any] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }
            
            self.sendNotification()
            self.thanksView.isHidden = false
        })
    }
    
    @IBAction func rejectTapped(_ sender: Any) {
    }
    
    @IBAction func fixAnotherTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("fix_again"), object: nil)
    }
}
