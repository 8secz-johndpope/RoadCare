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
    @IBOutlet weak var sbSeeChart: SimpleButton!
    @IBOutlet weak var sbSeeOtherPotholes: SimpleButton!
    
    var allPotholes = [PotholeDetails]()
    var groupedReports = [GroupedPotholes]()
    var groupedPrrts = [GroupedPRRTPotholes]()

    var requestPotholes: DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StatisticPRRTCell", bundle: nil),
                           forCellReuseIdentifier: "StatisticPRRTCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        requestPotholes?.cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getReportedPotholes(page: "1", request_index: 1)
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
                    self.setupChart()
                }
            }
        })
    }
    
    private func setupChart() {
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
        
        self.groupedReports.removeAll()
        self.groupedPrrts.removeAll()
        
        for child in dict {
            self.groupedReports.append(child.value)
            let group_prrt = GroupedPRRTPotholes(city: child.value.city,
                                                 country:child.value.country,
                                                 prrt: self.calculatePRRTAverage(group: child.value))
            self.groupedPrrts.append(group_prrt)
        }

        self.tableView.reloadData()
        
        if groupedPrrts.count == 0 {
            self.sbSeeChart.isEnabled = false
        } else {
            self.sbSeeChart.isEnabled = true
        }
    }
    
    private func calculatePRRTAverage(group: GroupedPotholes) -> Double {
        var sum: Double = 0.0
        var count = 0
        for pothole in group.report_array {
            if pothole.metaBox?.repaired_status.lowercased() == REPAIRED.lowercased() {
                sum += DateUtils.getDateDistance(s1: pothole.date!, s2: pothole.modified!)
                count += 1
            }
        }
        return sum/Double(count)
    }
    
    // MARK: Button actions.
    
    @IBAction func seeChatTapped(_ sender: Any) {
        let viewController = StatisticsPRRTViewController(nibName: "StatisticsPRRTViewController", bundle: nil)
        viewController.groupedPrrts = self.groupedPrrts
        navigationController?.pushViewController(viewController, animated: true)
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

        let city = self.groupedReports[indexPath.row].city
        let country = self.groupedReports[indexPath.row].country
        cell.lblCity.text = city + ", " + country
        cell.lblAverage.text = String(format: "%0.01f", self.groupedPrrts[indexPath.row].prrt)
        
        return cell
    }
}
