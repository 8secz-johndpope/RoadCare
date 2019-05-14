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
    var potholes = [PotholeDetails]()
    var allPotholes = [PotholeDetails]()
    
    var navTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        tableView.register(UINib(nibName: "PotholeDetailViewCell", bundle: nil), forCellReuseIdentifier: "PotholeDetailViewCell")
        tableView.reloadData()
        
        self.navTitle = "Potholes Reported in " + Location.city + ", " + Location.country
        navigationItem.title = self.navTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getReportedPotholes(page: "1", request_index: 1)
    }
    
    private func getReportedPotholes(page: String, request_index: Int) {
        showProgress(message: "")
        
        _ = APIClient.getPosts(page: page, handler: { (success, pages, data) in
            self.dismissProgress()
            guard success, data != nil, let response = data as? [[String: Any]] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }
            
            if request_index == 1 {
                self.allPotholes.removeAll()
            }
            for json in response {
                self.allPotholes.append(PotholeDetails(json))
            }

            let count = Int(pages ?? "1")
            if count != nil {
                if request_index < count! {
                    self.getReportedPotholes(page: pages!, request_index: request_index+1)
                } else {
                    self.setupPotholeList()
                }
            }
        })
    }
    
    private func setupPotholeList() {
        potholes.removeAll()
        for child in allPotholes {
            if (child.metaBox?.city.containsIgnoringCase(find: Location.city))! {
                potholes.append(child)
            }
        }
        self.tableView.reloadData()
    }

    @objc func seeDetails(sender: SimpleButton!) {
        let viewController = PotholeDetailsViewController(nibName: "PotholeDetailsViewController", bundle: nil)
        viewController.selPothole = potholes[sender.tag]
        POTHOLE_ID = viewController.selPothole!.id
        viewController.navTitle = self.navTitle
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    @objc func reportAgain(sender: SimpleButton!) {
        let selPothole = potholes[sender.tag]
        
        showProgress(message: "")
        
        let metaBox: [String: Any] = [
            "repaired_status": NOT_REPAIRED
        ]
        let params: [String: Any] = [
            "meta_box": metaBox
        ]
        
        _ = APIClient.updatePotholePhoto(id: selPothole.id, params: params, handler: { (success, error, data) in
            self.dismissProgress()
            
            guard success, data != nil, let _ = data as? [String: Any] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }
            
            self.getReportedPotholes(page: "1", request_index: 1)
        })
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
        potholeCell.titleButton.tag = indexPath.row
        potholeCell.titleButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        potholeCell.detailsButton.tag = indexPath.row
        potholeCell.detailsButton.addTarget(self, action: #selector(seeDetails), for: .touchUpInside)
        potholeCell.reportButton.tag = indexPath.row
        potholeCell.reportButton.addTarget(self, action: #selector(reportAgain), for: .touchUpInside)
        
        potholeCell.setupView(details: potholes[indexPath.row])
        
        if selectedIndexs.contains(indexPath.row) {
            potholeCell.bodyView.isHidden = false
        } else {
            potholeCell.bodyView.isHidden = true
        }

        return potholeCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return potholes.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
