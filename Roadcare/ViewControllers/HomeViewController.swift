//
//  HomeViewController.swift
//  Roadcare
//
//  Created by macbook on 4/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation
import Alamofire

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var titleView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblReportedCount: UILabel!
    @IBOutlet weak var lblReportedStatus: UILabel!
    @IBOutlet weak var lblRepairedCount: UILabel!
    @IBOutlet weak var lblReactionTimer: UILabel!
    @IBOutlet weak var reportedLoading: UIActivityIndicatorView!
    @IBOutlet weak var repairedLoading: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    var timer: Timer?
    var potholes = [PotholeDetails]()
    var allPotholes = [PotholeDetails]()

    var requestPotholes: DataRequest?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup navigation bar.
        tabBarController?.navigationItem.title = ""
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white"), style: .plain, target: self, action: #selector(didTapMenu))
        tabBarController?.navigationItem.titleView = titleView

        NotificationCenter.default.addObserver(self, selector: #selector(reportAgain(notification:)), name: Notification.Name("report_again"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fixAnotherPotholes(notification:)), name: Notification.Name("fix_again"), object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        requestPotholes?.cancel()
    }
    
    private func getReportedPotholes(page: String, request_index: Int) {
        
        requestPotholes = APIClient.getPosts(page: page, handler: { (success, pages, data) in
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
        var repaired_count = 0
        potholes.removeAll()
        for child in allPotholes {
            if (child.metaBox?.city.containsIgnoringCase(find: Location.city))! {
                potholes.append(child)
                if child.metaBox?.repaired_status.lowercased() == REPAIRED.lowercased() {
                    repaired_count += 1
                }
            }
        }
        lblReportedCount.text = String(potholes.count)
        lblRepairedCount.text = String(repaired_count)
        lblReportedCount.isHidden = false
        lblRepairedCount.isHidden = false
        reportedLoading.stopAnimating()
        repairedLoading.stopAnimating()
    }
    
    @objc func runTimedCode() {
        lblDate.text =  DateUtils.convertDateToStr(date: Date(), format: "dd MMM yyyy · hh:mm a")
    }
    
    private func initLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func reportAgain(notification: NSNotification) {
        if let tabBarController = self.navigationController?.topViewController as? UITabBarController {
            if tabBarController.selectedIndex == 0 {
                let viewController = ReportPotholeViewController(nibName: "ReportPotholeViewController", bundle: nil)
                navigationController!.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @objc func fixAnotherPotholes(notification: NSNotification) {
        let viewController = ListPotholesViewController(nibName: "ListPotholesViewController", bundle: nil)
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapMenu() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    @IBAction func reportPothole(_ sender: SimpleButton) {
        let viewController = ReportPotholeViewController(nibName: "ReportPotholeViewController", bundle: nil)
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    // MARK: Location Manager delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            Location.city = locality!
            Location.country = country!
            lblLocation.text = Location.city + ", " + Location.country
            lblReportedStatus.text = "Potholes Reported in " + Location.city + " in 2019"
            
            getReportedPotholes(page: "1", request_index: 1)
            reportedLoading.startAnimating()
            repairedLoading.startAnimating()
            lblReportedCount.isHidden = true
            lblRepairedCount.isHidden = true
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}
