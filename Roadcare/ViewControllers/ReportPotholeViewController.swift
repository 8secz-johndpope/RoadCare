//
//  ReportPotholeViewController.swift
//  Roadcare
//
//  Created by macbook on 4/10/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class ReportPotholeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Report a Pothole"
    }

    @IBAction func nextButtonTapped(_ sender: SimpleButton) {
        let viewController = MappingPotholesViewController(nibName: "MappingPotholesViewController", bundle: nil)
        navigationController!.pushViewController(viewController, animated: true)
    }
}
