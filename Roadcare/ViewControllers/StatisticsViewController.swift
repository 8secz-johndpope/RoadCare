//
//  StatisticsViewController.swift
//  Roadcare
//
//  Created by macbook on 5/13/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import Alamofire
import CountryPickerView

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sbSeeChart: SimpleButton!
    @IBOutlet weak var sbSeeOtherPotholes: SimpleButton!
    @IBOutlet weak var sbPrrt: SimpleButton!
    @IBOutlet weak var prrtHeaderView: UIView!
    @IBOutlet weak var potholesHeaderView: UIView!
    @IBOutlet weak var filteringView: UIView!
    @IBOutlet weak var tfFilterCountry: UITextField!
    
    var allPotholes = [PotholeDetails]()
    var groupedReports = [GroupedPotholes]()
    var groupedPrrts = [GroupedPRRTPotholes]()
    
    var requestPotholes: DataRequest?
    var prrt_view_flag: Bool = true
    var filter_flag: Bool = false
    var btnFilter: UIBarButtonItem?
    var btnClose: UIBarButtonItem?
    
    let cpvInternal = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StatisticPRRTCell", bundle: nil),
                           forCellReuseIdentifier: "StatisticPRRTCell")
        tableView.register(UINib(nibName: "StatisticPotholesCell", bundle: nil),
                           forCellReuseIdentifier: "StatisticPotholesCell")

        potholesHeaderView.isHidden = true
        prrtHeaderView.isHidden = false
        
        cpvInternal.delegate = self
        cpvInternal.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        requestPotholes?.cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if filter_flag {
           return
        }

        btnClose = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(didTapClose))
        btnFilter = UIBarButtonItem(image: UIImage(named: "ic_filter"), style: .plain, target: self, action: #selector(didTapFilter))
        tabBarController?.navigationItem.rightBarButtonItem = btnFilter

        self.filteringView.isHidden = true
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
                    self.setupChart(filter: "")
                }
            }
        })
    }
    
    private func setupChart(filter: String) {
        var dict: [String: GroupedPotholes] = [:]

        self.allPotholes.forEach { report in
            let city = report.metaBox!.city ?? ""
            let country = report.metaBox?.country ?? ""
            if filter == "" {
                if let groupedReport = dict[city] {
                    groupedReport.report_array.append(report)
                } else {
                    let groupedReport = GroupedPotholes(city: city, country: country)
                    groupedReport.report_array.append(report)
                    dict[city] = groupedReport
                }
            } else if country == filter {
                if let groupedReport = dict[city] {
                    groupedReport.report_array.append(report)
                } else {
                    let groupedReport = GroupedPotholes(city: city, country: country)
                    groupedReport.report_array.append(report)
                    dict[city] = groupedReport
                }
            }
        }
        
        self.groupedReports.removeAll()
        self.groupedPrrts.removeAll()
        
        for child in dict {
            self.groupedReports.append(child.value)
            let group_prrt = self.setupPotholesData(group: child.value)
            self.groupedPrrts.append(group_prrt)
        }

        self.tableView.reloadData()
        
        if groupedPrrts.count == 0 {
            self.sbSeeChart.isEnabled = false
        } else {
            self.sbSeeChart.isEnabled = true
        }
    }
    
    private func setupPotholesData(group: GroupedPotholes) -> GroupedPRRTPotholes {
        var sum: Double = 0.0
        var count = 0
        var reported_count = 0
        var repaired_count = 0

        for pothole in group.report_array {
            if pothole.metaBox?.repaired_status.lowercased() == REPAIRED.lowercased() {
                sum += DateUtils.getDateDistance(s1: pothole.date!, s2: pothole.modified!)
                count += 1
            }
            reported_count += 1
            if pothole.metaBox?.repaired_status.lowercased() == REPAIRED.lowercased() {
                if pothole.date != "" && pothole.modified != "" {
                    repaired_count += 1
                }
            }
        }
        let data = GroupedPRRTPotholes(city: group.city,
                                       country: group.country,
                                       prrt: sum/Double(count),
                                       reported_count: reported_count,
                                       filled_count: repaired_count)
        return data
    }
    
    @objc func didTapFilter() {
        self.filteringView.isHidden = false
        tabBarController?.navigationItem.rightBarButtonItem = btnClose
    }
    
    @objc func didTapClose() {
        self.filteringView.isHidden = true
        tabBarController?.navigationItem.rightBarButtonItem = btnFilter
    }
    
    // MARK: Button actions.
    
    @IBAction func seeChatTapped(_ sender: Any) {
        filter_flag = false
        
        if prrt_view_flag {
            let viewController = StatisticsPRRTViewController(nibName: "StatisticsPRRTViewController", bundle: nil)
            viewController.groupedPrrts = self.groupedPrrts
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = StatisticPotholesChartViewController(nibName: "StatisticPotholesChartViewController", bundle: nil)
            viewController.groupedPrrts = self.groupedPrrts
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func seeOtherCitiesTapped(_ sender: Any) {
        prrt_view_flag = false
        potholesHeaderView.isHidden = false
        prrtHeaderView.isHidden = true
        sbSeeOtherPotholes.isHidden = true
        sbPrrt.isHidden = false
        self.tableView.reloadData()
    }
    
    @IBAction func seePrrtTapped(_ sender: Any) {
        prrt_view_flag = true
        potholesHeaderView.isHidden = true
        prrtHeaderView.isHidden = false
        sbSeeOtherPotholes.isHidden = false
        sbPrrt.isHidden = true
        self.tableView.reloadData()
    }
    
    @IBAction func countryTapped(_ sender: Any) {
        filter_flag = true
        cpvInternal.showCountriesList(from: self)
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        guard let country = tfFilterCountry.text, country.count != 0 else {
            showSimpleAlert(message: "Please select country for filtering.")
            tfFilterCountry.becomeFirstResponder()
            return
        }

        self.filteringView.isHidden = true
        tabBarController?.navigationItem.rightBarButtonItem = btnFilter
        
        setupChart(filter: self.tfFilterCountry.text!)
    }
    
    // MARK: TableView DataSource and Delegate Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupedReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if prrt_view_flag {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticPRRTCell", for: indexPath) as! StatisticPRRTCell
            
            let city = self.groupedReports[indexPath.row].city
            let country = self.groupedReports[indexPath.row].country
            cell.lblCity.text = city + ", " + country
            cell.lblAverage.text = String(format: "%0.01f", self.groupedPrrts[indexPath.row].prrt)

            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticPotholesCell", for: indexPath) as! StatisticPotholesCell
            
            let city = self.groupedReports[indexPath.row].city
            let country = self.groupedReports[indexPath.row].country
            cell.lblCity.text = city + ", " + country
            cell.lblReportedCount.text = String(format: "%d", self.groupedPrrts[indexPath.row].reported_count)
            cell.lblFilledCount.text = String(format: "%d", self.groupedPrrts[indexPath.row].filled_count)
            
            return cell
        }
    }
}

extension StatisticsViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        tfFilterCountry.text = country.localizedName
        if country.localizedName == "Palestinian Territories" {
            tfFilterCountry.text = "Palestine"
        }
    }
}

extension StatisticsViewController: CountryPickerViewDataSource {
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
}
