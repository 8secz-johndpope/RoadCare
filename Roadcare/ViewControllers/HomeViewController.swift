//
//  HomeViewController.swift
//  Roadcare
//
//  Created by macbook on 4/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {

    @IBOutlet var titleView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup navigation bar.
        tabBarController?.navigationItem.title = ""
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white"), style: .plain, target: self, action: #selector(didTapMenu))
        tabBarController?.navigationItem.titleView = titleView

    }
    
    @objc func didTapMenu() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    @IBAction func reportPothole(_ sender: SimpleButton) {
        let viewController = ReportPotholeViewController(nibName: "ReportPotholeViewController", bundle: nil)
        navigationController!.pushViewController(viewController, animated: true)
    }
}
