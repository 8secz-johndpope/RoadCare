//
//  PhotoPotholeViewController.swift
//  Roadcare
//
//  Created by macbook on 4/10/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import Alamofire

class PhotoPotholeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ivPothole: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    var requestFileUpload: DataRequest?
    var requestPhotoUpdate: DataRequest?
    
    var id: Int! = 0
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Photo of the Pothole".localized
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        ivPothole.tag = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        requestFileUpload?.cancel()
        requestPhotoUpdate?.cancel()
    }
    
    private func getBase64Code() -> String? {
        if let image = ivPothole.image, let imageData = image.jpegData(compressionQuality: 0.4) {
            let prefix = "data:image/jpg;base64,"
            let base64str = imageData.base64EncodedString(options: .lineLength64Characters)
            return prefix + base64str
        }
        return nil
    }

    private func uploadWithAlamofire() {
        self.showProgress(message: "")
        
        let image = ivPothole.image
        let parameters = [
            "title": "file" + String(self.id)
        ]
        
        let user = "admin"
        let password = "pass"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = image?.jpegData(compressionQuality: 1) {
                if Double(imageData.count) / 1000.0 > 500.0 {
                    let convertedData = image?.jpegData(compressionQuality: CGFloat(300000)/CGFloat(imageData.count))
                    multipartFormData.append(convertedData!, withName: "file", fileName: "file.png", mimeType: "image/png")
                } else {
                    multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
                }
            }
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
                                    self.saveFilePath(path: response.url!)
                                }
                            }
                        })
                    case .failure(let encodingError):
                        self.dismissProgress()
                        print("error:\(encodingError)")
                    }
        })
    }
    
    private func uploadPotholePotho() {
        showProgress(message: "")
        
        requestFileUpload = APIClient.uploadNewFile(file: getBase64Code()!, handler: { (success, error, data) in
            self.dismissProgress()
            guard success, data != nil, let json = data as? [String: Any] else {
                self.showSimpleAlert(message: "Failed to upload file. Please try again")
                return
            }

            let response = MediaDetails(json)
            if response.url != nil {
                self.saveFilePath(path: response.url!);
            }
        })
    }
    
    private func saveFilePath(path: String) {
        showProgress(message: "")
        
        let metaBox: [String: Any] = [
            "pothole_photo": path
        ]
        let params: [String: Any] = [
            "meta_box": metaBox
        ]
        requestPhotoUpdate = APIClient.updatePotholePhoto(id: id, params: params, handler: { (success, error, data) in
            self.dismissProgress()
            
            guard success, data != nil, let _ = data as? [String: Any] else {
                self.showSimpleAlert(message: "Request failed. Please try again")
                return
            }

            self.gotoThanksPage()
        })
    }
    
    private func gotoThanksPage() {
        let viewController = ThanksReportViewController(nibName: "ThanksReportViewController", bundle: nil)
        navigationController!.pushViewController(viewController, animated: true)
    }

    // MARK: Button click actions
    
    @IBAction func didTapGallery(_ sender: SimpleButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true)
    }
    
    @IBAction func didCamButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        if (ivPothole.tag == 0) {
            self.showSimpleAlert(message: "Please select pothole potho")
        } else {
            uploadWithAlamofire()
        }
    }
    
    @IBAction func skipBtnTapped(_ sender: Any) {
        gotoThanksPage()
    }
    
    // MARK: UIImagePickerController Delegate Method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            ivPothole.image = pickedImage
            ivPothole.tag = 1
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
