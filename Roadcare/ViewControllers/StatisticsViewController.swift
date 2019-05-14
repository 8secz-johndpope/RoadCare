//
//  StatisticsViewController.swift
//  Roadcare
//
//  Created by macbook on 5/13/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import Alamofire

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var allPotholes = [PotholeDetails]()
    var groupedReports = [GroupedPotholes]()

    var requestPotholes: DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StatisticPRRTCell", bundle: nil), forCellReuseIdentifier: "StatisticPRRTCell")
        
        getReportedPotholes(page: "1", request_index: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        requestPotholes?.cancel()
    }
    
    private func getReportedPotholes(page: String, request_index: Int) {
        showProgress(message: "")
        
        requestPotholes = APIClient.getPosts(page: page, handler: { (success, pages, data) in
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
                    self.setupChat()
                }
            }
        })
    }
    
    private func setupChat() {
        var dict: [String: GroupedPotholes] = [:]

        self.allPotholes.forEach { report in
            let city = report.metaBox!.city ?? ""
            let country = report.metaBox?.country ?? ""
            if let groupedReport = dict[city] {
                groupedReport.report_array.append(report)
            } else {
                let groupedReport = GroupedPotholes(city: city, country: country)
                groupedReport.report_array.append(report)
                dict[city] = groupedReport
            }
        }
        
        for child in dict {
            self.groupedReports.append(child.value)
        }

        self.tableView.reloadData()
    }
    
    private func calculatePRRTAverage(group: GroupedPotholes) -> String {
        var sum: Double = 0.0
        var count = 0
        for pothole in group.report_array {
            if pothole.metaBox?.repaired_status == REPAIRED {
                sum += DateUtils.getDateDistance(s1: pothole.date!, s2: pothole.modified!)
                count += 1
            }
        }
        if sum == 0 {
            return ""
        }
        return String(format: "%.01f", sum/Double(count))
    }
    
    // MARK: Button actions.
    
    @IBAction func seeChatTapped(_ sender: Any) {
    }
    
    @IBAction func seeOtherCitiesTapped(_ sender: Any) {
    }
    
    // MARK: TableView DataSource and Delegate Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupedReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticPRRTCell", for: indexPath) as! StatisticPRRTCell
        
        cell.lblCity.text = self.groupedReports[indexPath.row].city
        cell.lblAverage.text = self.calculatePRRTAverage(group: self.groupedReports[indexPath.row])
        
        return cell
    }
}
