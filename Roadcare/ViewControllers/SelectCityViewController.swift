//
//  SelectCityViewController.swift
//  Roadcare
//
//  Created by macbook on 5/16/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import CountryPickerView

class SelectCityViewController: UIViewController {

    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfLanguage: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let cpvInternal = CountryPickerView()
    
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
    }

    @IBAction func countryTapped(_ sender: Any) {
        cpvInternal.showCountriesList(from: self)
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
        
        LocalStorage["selected_country"] = country
        if country == "Palestinian Territories" {
            LocalStorage["selected_country"] = "Palestine"
        }
        LocalStorage["selected_city"] = city
        LocalStorage["app_language"] = lang
        
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
