//
//  FixPotholesViewController.swift
//  Roadcare
//
//  Created by macbook on 5/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class FixPotholesViewController: UIViewController {

    @IBOutlet weak var sbHot: SimpleButton!
    @IBOutlet weak var sbHotSel: SimpleButton!
    @IBOutlet weak var sbCold: SimpleButton!
    @IBOutlet weak var sbColSel: SimpleButton!
    @IBOutlet weak var sbPlain: SimpleButton!
    @IBOutlet weak var sbPlainSel: SimpleButton!
    @IBOutlet weak var sbStone: SimpleButton!
    @IBOutlet weak var sbStoneSel: SimpleButton!
    @IBOutlet weak var sbOther: SimpleButton!
    @IBOutlet weak var sbOtherSel: SimpleButton!
    @IBOutlet weak var tfOther: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var materials = ["", "", "", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func hotBtnTapped(_ sender: Any) {
        if materials[0] == "" {
            materials[0] = "hot"
            sbHot.isHidden = true
            sbHotSel.isHidden = false
        } else {
            materials[0] = ""
            sbHot.isHidden = false
            sbHotSel.isHidden = true
        }
    }
    
    @IBAction func coldBtnTapped(_ sender: Any) {
        if materials[1] == "" {
            materials[1] = "cold"
            sbCold.isHidden = true
            sbColSel.isHidden = false
        } else {
            materials[1] = ""
            sbCold.isHidden = false
            sbColSel.isHidden = true
        }
    }
    
    @IBAction func plainBtnTapped(_ sender: Any) {
        self.showSimpleAlert(message: "This Material is inappropriate, please use" +
            "an appropriate material to fill up this pothole")
//        if materials[2] == "" {
//            materials[2] = "plain"
//            sbPlain.isHidden = true
//            sbPlainSel.isHidden = false
//        } else {
//            materials[2] = ""
//            sbPlain.isHidden = false
//            sbPlainSel.isHidden = true
//        }
    }
    
    @IBAction func stoneBtnTapped(_ sender: Any) {
        self.showSimpleAlert(message: "This Material is inappropriate, please use" +
            "an appropriate material to fill up this pothole")
//        if materials[3] == "" {
//            materials[3] = "stone"
//            sbStone.isHidden = true
//            sbStoneSel.isHidden = false
//        } else {
//            materials[3] = ""
//            sbStone.isHidden = false
//            sbStoneSel.isHidden = true
//        }
    }
    
    @IBAction func otherBtnTapped(_ sender: Any) {
        if materials[4] == "" {
            materials[4] = "stone"
            sbOther.isHidden = true
            sbOtherSel.isHidden = false
            tfOther.isEnabled = true
        } else {
            materials[4] = ""
            sbOther.isHidden = false
            sbOtherSel.isHidden = true
            tfOther.isEnabled = false
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let viewController = PhotoPotholeViewController(nibName: "PhotoPotholeViewController", bundle: nil)
        viewController.fixing_flag = true
        viewController.id = POTHOLE_ID
        viewController.materials = materials.description
        navigationController!.pushViewController(viewController, animated: true)

//        let viewcontroller = SubmitFixedPotholesViewController(nibName: "SubmitFixedPotholesViewController", bundle: nil)
//        viewcontroller.materials = materials.description
//        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    @IBAction func signoutTapped(_ sender: Any) {
    }
    
    // MARK: Keyboard events.
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = -1 * keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
    }
}
