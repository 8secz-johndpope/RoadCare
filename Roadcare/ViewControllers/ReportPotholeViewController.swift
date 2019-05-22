//
//  ReportPotholeViewController.swift
//  Roadcare
//
//  Created by macbook on 4/10/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AVFoundation

class ReportPotholeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var tfStreedName: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfNearby: UITextField!
    @IBOutlet weak var tfReporterName: UITextField!
    @IBOutlet weak var tfPhoneNum: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var requestCities: DataRequest?
    var requestAudioUpdate: DataRequest?
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var meterTimer: Timer!
    var soundFileURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Report a Pothole"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tfStreedName.text = ""
        tfCity.text = Location.detectedCity
        tfNearby.text = ""
        tfReporterName.text = ""
        tfPhoneNum.text = ""
//        topConstraint.constant = 30
        
        initLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        requestCities?.cancel()
        requestAudioUpdate?.cancel()
    }
    
    private func initLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func nextButtonTapped(_ sender: SimpleButton) {
        guard let city = tfCity.text, city.count != 0 else {
            showSimpleAlert(message: "Please input city")
            return
        }

        checkCityName()
    }
    
    @IBAction func pushTalkTouchDown(_ sender: Any) {
        if player != nil && player.isPlaying {
            print("stopping")
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.isRecording {
            print("pausing")
            recorder.pause()
            
        } else {
            print("recording")
            //            recorder.record()
            recordWithPermission(false)
        }
    }
    
    @IBAction func pushTalkTouchUpInside(_ sender: Any) {
        print("1")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    private func getBase64Code() -> String? {
        var url: URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }

        do {
            let audioData = try Data(contentsOf: url!)
            let encodeString = audioData.base64EncodedString()
            return encodeString

        } catch {
            return nil
        }
    }
    
    func setupRecorder() {
        print("\(#function)")
        
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self as? AVAudioRecorderDelegate
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }
    }

    func recordWithPermission(_ setup: Bool) {
        print("\(#function)")
        
        AVAudioSession.sharedInstance().requestRecordPermission {
            [unowned self] granted in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                }
            } else {
                print("Permission to record not granted")
            }
        }
        
        if AVAudioSession.sharedInstance().recordPermission == .denied {
            print("permission denied")
        }
    }
    
    func setSessionPlayback() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playback, mode: .default)
            
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try
                session.setCategory(.playAndRecord, mode: .default)
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }

    private func uploadRecordedAudioFile(id: Int) {
        showProgress(message: "")
        
        var url: URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        
        let parameters = [
            "title": "audio_file"
        ]
        
        let user = "admin"
        let password = "pass"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(url!, withName: "file", fileName: "audio.mp3", mimeType: "audio/*")
//            multipartFormData.append(self.getBase64Code(), withName: "file", fileName: "audio.mp3", mimeType: "audio/*")
            
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }}, to: "http://dev.skyconst.com/wp-json/wp/v2/media", method: .post, headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (data) in
                            self.dismissProgress()
                            if let error = data.error {
                                print(error)
                                self.showSimpleAlert(message: "Request failed. Please try again")
                                return
                            }
                            if let jsonResponse = data.result.value as? [String: Any] {
                                
                                let response = MediaDetails(jsonResponse)
                                if response.url != nil {
                                    self.saveFilePath(path: response.url!, id: id)
                                }
                            }
                        })
                    case .failure(let encodingError):
                        self.dismissProgress()
                        print("error:\(encodingError)")
                    }
        })
    }
    
    private func saveFilePath(path: String, id: Int) {
        showProgress(message: "")
        
        let metaBox: [String: Any] = [
            "audio": path
        ]
        let params: [String: Any] = [
            "meta_box": metaBox
        ]
        requestAudioUpdate = APIClient.updatePotholePhoto(id: id, params: params, handler: { (success, error, data) in
            self.dismissProgress()
            
            guard success, data != nil, let _ = data as? [String: Any] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }
        })
    }
    
    private func checkCityName() {
        showProgress(message: "")
        
        if requestCities == nil { requestCities?.cancel() }
        
        requestCities = APIClient.getCategories(handler: { (success, error, data) in
            self.dismissProgress()
            guard success, data != nil, let response = data as? [[String: Any]] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }
            AppConstants.cities.removeAll()
            
            var flag = false
            for json in response {
                let city = City(json)
                AppConstants.cities.append(city)
                if city.name.lowercased() == self.tfCity.text?.lowercased() {
                    flag = true
                    break
                }
            }
            if flag {
                self.submitNewPothole()
            } else {
                self.showSimpleAlert(message: "Sorry, your city is no longer registered with us")
            }
        })
    }
    
    private func submitNewPothole() {
        showProgress(message: "")
        
        let details = PotholeDetails();
        details.title = tfStreedName.text! + " ," + tfCity.text!
        details.status = "publish"
        
        let metaBox = MetaBox()
        metaBox.street_name = tfStreedName.text
        metaBox.city = tfCity.text
        metaBox.reporter_name = tfReporterName.text
        metaBox.phone_number = tfPhoneNum.text
        metaBox.nearby_places = tfNearby.text
        metaBox.reported_number = "1"
        
        details.metaBox = metaBox
        
        _ = APIClient.reportPothole(params: details, handler: { (success, error, data) in
            self.dismissProgress()
            guard success, data != nil, let json = data as? [String: Any] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }
            
            let response = PotholeDetails(json)
            
            if response.id == nil {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            } else {
                if self.recorder != nil {
                    self.uploadRecordedAudioFile(id: response.id)
                } else {
                    let viewController = MappingPotholesViewController(nibName: "MappingPotholesViewController", bundle: nil)
                    viewController.id = response.id
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
            }
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = -1 * keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
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
            containsPlacemark.subLocality
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            Location.detectedCity = locality!
            tfCity.text = locality!
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}
