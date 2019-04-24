//
//  StartupViewController.swift
//  Roadcare
//
//  Created by macbook on 4/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedTapped(_ sender: UIButton) {
        let viewController = TermsConditionsViewController(nibName: "TermsConditionsViewController", bundle: nil)
        present(viewController, animated: true, completion: nil)
    }
}
