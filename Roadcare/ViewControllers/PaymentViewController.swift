//
//  PaymentViewController.swift
//  Roadcare
//
//  Created by macbook on 4/8/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var monthlyOptionView: UIView!
    @IBOutlet weak var annualOptionView: UIView!
    @IBOutlet weak var thanksView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        monthlyOptionView.isHidden = false
        annualOptionView.isHidden = true
        thanksView.isHidden = true
    }

    @IBAction func monthlySelected(_ sender: UIButton) {
        monthlyOptionView.isHidden = false
        annualOptionView.isHidden = true
    }
    
    @IBAction func annualSelected(_ sender: UIButton) {
        monthlyOptionView.isHidden = true
        annualOptionView.isHidden = false
    }
    
    @IBAction func paymentBtnTapped(_ sender: SimpleButton) {
        thanksView.isHidden = false
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
