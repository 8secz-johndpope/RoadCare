//
//  SelectCityViewController.swift
//  Roadcare
//
//  Created by macbook on 5/16/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import CountryPickerView
import Alamofire
import SwiftyPickerPopover

class SelectCityViewController: UIViewController {

    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfLanguage: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let cpvInternal = CountryPickerView()
    
    var requestCities: DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.title = "Set Country"

        cpvInternal.delegate = self
        cpvInternal.dataSource = self
        
        tfCountry.text = AppConstants.getCountry()
        tfCity.text = AppConstants.getCity()
        tfLanguage.text = AppConstants.getLanguage()
        
        checkCityName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        requestCities?.cancel()
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
            
            for json in response {
                let city = City(json)
                AppConstants.cities.append(city)
            }
            if AppConstants.cities.count != 0 {
                self.tfCity.text = AppConstants.cities[0].name
            }
        })
    }
    
    private func showCitiesPopup() {
        var items = [String]()
        for city in AppConstants.cities {
            if tfCountry.text == city.country {
                items.append(city.name)
            }
        }
        if items.count == 0 { return }
        
        StringPickerPopover(title: "", choices: items)
            .setSelectedRow(0)
            .setDoneButton(action: { (popover, selectedRow, selectedString) in
                self.tfCity.text = selectedString
            })
            .setCancelButton(action: { (_, _, _) in })
            .appear(originView: self.tfCity, baseViewController: self)
    }
    
    @IBAction func countryTapped(_ sender: Any) {
        cpvInternal.showCountriesList(from: self)
    }
    
    @IBAction func cityTapped(_ sender: Any) {
        self.showCitiesPopup()
    }
    
    @IBAction func langTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Select a language", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "English", style: .default, handler: { (action) in
            self.tfLanguage.text = "English"
        }))
        alertController.addAction(UIAlertAction(title: "Arabic", style: .default, handler: { (action) in
            self.tfLanguage.text = "Arabic"
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        guard let country = tfCountry.text, country.count != 0 else {
            showSimpleAlert(message: "Please select a country")
            tfCountry.becomeFirstResponder()
            return
        }
        guard let city = tfCity.text, city.count != 0 else {
            showSimpleAlert(message: "Please input city name")
            tfCountry.becomeFirstResponder()
            return
        }
        guard let lang = tfLanguage.text, lang.count != 0 else {
            showSimpleAlert(message: "Please select a language")
            tfLanguage.becomeFirstResponder()
            return
        }
        
        LocalStorage[SELECTED_COUNTRY] = country
        if country == "Palestinian Territories" {
            LocalStorage[SELECTED_COUNTRY] = "Palestine"
        }
        LocalStorage["selected_city"] = city
        LocalStorage[APP_LANGUAGE] = lang
        
        if LocalStorage["terms_agrees"].object != nil {
            let appDelegate =  UIApplication.shared.delegate as! AppDelegate
            appDelegate.showDashboard()

        } else {
            let viewController = TermsConditionsViewController(nibName: "TermsConditionsViewController", bundle: nil)
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = -1 * keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
    }
}

extension SelectCityViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        tfCountry.text = country.localizedName
        if country.localizedName == "Palestinian Territories" {
            tfCountry.text = "Palestine"
        }
        tfCity.text = ""
    }
}

extension SelectCityViewController: CountryPickerViewDataSource {
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


extension UITextField {
    func showDoneButtonOnKeyboard() {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        
        var toolBarItems = [UIBarButtonItem]()
        toolBarItems.append(flexSpace)
        toolBarItems.append(doneButton)
        
        let doneToolbar = UIToolbar()
        doneToolbar.items = toolBarItems
        doneToolbar.sizeToFit()
        
        inputAccessoryView = doneToolbar
    }
}
