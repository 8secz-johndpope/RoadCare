//
//  ListPotholesViewController.swift
//  Roadcare
//
//  Created by macbook on 4/10/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import YNExpandableCell

class ListPotholesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndexs: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        tableView.register(UINib(nibName: "PotholeDetailViewCell", bundle: nil), forCellReuseIdentifier: "PotholeDetailViewCell")
        tableView.reloadData()
    }

    @objc func seeDetails(sender: SimpleButton!) {
        let viewController = PotholeDetailsViewController(nibName: "PotholeDetailsViewController", bundle: nil)
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    @objc func reportAgain(sender: SimpleButton!) {
        
    }
    
    @objc func expandButtonTapped(sender: UIButton!) {
        if !selectedIndexs.contains(sender.tag) {
            selectedIndexs.append(sender.tag)
        } else {
            selectedIndexs.remove(at: selectedIndexs.index(of: sender.tag)!)
        }
        self.tableView.reloadData()
//        self.tableView.beginUpdates()
//        self.tableView.endUpdates()
    }

    // MARK: YNTableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndexs.contains(indexPath.row) {
            return 420
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let potholeCell = tableView.dequeueReusableCell(withIdentifier: PotholeDetailViewCell.ID) as! PotholeDetailViewCell
        potholeCell.titleLabel.text = "An-Najah St., Nablus, Palestine"
        potholeCell.titleButton.tag = indexPath.row
        potholeCell.titleButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        potholeCell.detailsButton.tag = indexPath.row
        potholeCell.detailsButton.addTarget(self, action: #selector(seeDetails), for: .touchUpInside)
        potholeCell.reportButton.tag = indexPath.row
        potholeCell.reportButton.addTarget(self, action: #selector(reportAgain), for: .touchUpInside)
        
        if selectedIndexs.contains(indexPath.row) {
            potholeCell.bodyView.isHidden = false
        } else {
            potholeCell.bodyView.isHidden = true
        }

        return potholeCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
