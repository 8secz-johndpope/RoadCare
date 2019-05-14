//
//  MappingPotholesViewController.swift
//  Roadcare
//
//  Created by macbook on 4/17/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MappingPotholesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    var id: Int! = 0
    var lat: String?
    var lng: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        
        lat = String(annotation.coordinate.latitude)
        lng = String(annotation.coordinate.longitude)
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        lat = String(userLocation.coordinate.latitude)
        lng = String(userLocation.coordinate.longitude)
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Marker Selected")
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error \(error)")
    }

    @IBAction func nextBtnTapped(_ sender: SimpleButton) {
        if lat == nil || lng == nil {
            return
        }
        showProgress(message: "")
        
        _ = APIClient.updatePotholeLocation(id: id, lat: lat!, lng: lng!, handler: { (success, error, data) in
            guard success, data != nil, let json = data as? [String: Any] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }

            let response = PotholeDetails(json)
            
            if response.id == nil {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            } else {
                self.gotoNextPage()
            }
        })
    }
    
    @IBAction func skipBtnTapped(_ sender: SimpleButton) {
        gotoNextPage()
    }
    
    private func gotoNextPage() {
        let viewController = PhotoPotholeViewController(nibName: "PhotoPotholeViewController", bundle: nil)
        viewController.id = self.id
        navigationController!.pushViewController(viewController, animated: true)
    }
}
