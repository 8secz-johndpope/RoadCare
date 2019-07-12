//
//  PotholeDetailsViewController.swift
//  Roadcare
//
//  Created by macbook on 4/10/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit
import AVFoundation

class PotholeDetailsViewController: UIViewController {

    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblReportName: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    @IBOutlet weak var lblDateTime: UITextField!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fixPotholeConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPlayerTimer: UILabel!
    
    var selPothole: PotholeDetails?
    var navTitle: String?
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navTitle ?? ""
        
        if selPothole?.metaBox?.audio != "" {
//            let url = URL(string: (selPothole?.metaBox!.audio)!)
                    let url = URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3")
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            
            let playerLayer = AVPlayerLayer(player: player!)
            playerLayer.frame = CGRect(x:0, y:0, width:10, height:50)
            self.view.layer.addSublayer(playerLayer)
        }

        setupMapLocation()
        setupViews()
    }
    
    private func setupMapLocation() {
        let lat = Double(selPothole?.metaBox?.lat ?? "0")
        let lng = Double(selPothole?.metaBox?.lng ?? "0")
        if lat == nil && lng == nil {
            return
        }
        let center = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees);
        myAnnotation.title = "Pothole location"
        mapView.addAnnotation(myAnnotation)
    }
    
    private func setupViews() {
        let street = selPothole!.metaBox?.street_name ?? ""
        let city = selPothole!.metaBox?.city ?? ""
        lblReportName.text = selPothole?.metaBox?.reporter_name ?? ""
        lblAddress.text = street + ", " + city
        lblDateTime.text = selPothole?.modified ?? ""
        lblPhoneNumber.text = selPothole?.metaBox?.phone_number
        let status = selPothole?.metaBox?.repaired_status ?? ""
        if status.lowercased() == REPAIRED.lowercased() {
            fixPotholeConstraint.constant = 0
            lblStatus.text = REPAIRED
            imgStatus.image = UIImage(named: "ic_plus")
        } else {
            fixPotholeConstraint.constant = 50
            lblStatus.text = NOT_REPAIRED
            imgStatus.image = UIImage(named: "ic_minus")
        }
        if !AppUser.isLogin() {
            fixPotholeConstraint.constant = 0
        }
        let url = selPothole?.metaBox?.pothole_photo ?? ""
        imgPhoto.sd_setImage(with: URL(string: url),
                             placeholderImage: UIImage(named: "img_advertising_01"))
        SELECTED_POTHOLE_PHOTO = url
        
        lblPlayerTimer.isHidden = true
    }
    
    @IBAction func fixPothole(_ sender: SimpleButton) {
        let viewController = FixPotholesViewController(nibName: "FixPotholesViewController", bundle: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func listenComplaint(_ sender: SimpleButton) {
        if selPothole?.metaBox?.audio == "" {
            showToast(message: "No recorded audio file.")
            return
        }
        if player?.rate == 0 {
            player!.play()
            lblPlayerTimer.isHidden = false
            
            self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
                if self.player!.currentItem?.status == .readyToPlay {
                    let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                    
                    let secs = Int(currentTime)
                    self.lblPlayerTimer.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String
                }
            })

        } else {
            player!.pause()
            lblPlayerTimer.isHidden = true
        }
    }
}
