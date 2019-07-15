//
//  MenuViewController.swift
//  Roadcare
//
//  Created by macbook on 4/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import SideMenu

protocol MenuViewControllerDelegate {
    func didSelectMenu(index: Int)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var exportView: UIView!
    @IBOutlet weak var englishCheckbox: UIButton!
    @IBOutlet weak var arabicCheckbox: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    
    var delegate: MenuViewControllerDelegate?

    private class MenuItem {
        var index: Int!
        var icon: String!
        var text: String!
        
        init(index: Int!, icon: String!, text: String!) {
            self.index = index
            self.icon = icon
            self.text = text
        }
    }
    
    private var menuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup menu items.
        menuItems = [
            MenuItem(index: 1, icon: "ic_internet", text: "Country".localized),
            MenuItem(index: 2, icon: "ic_flag", text: "Language".localized),
            MenuItem(index: 3, icon: "ic_users", text: "Add Users".localized),
            MenuItem(index: 4, icon: "ic_placeholder", text: "Reported Potholes".localized),
        ]
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.isHidden = false
        self.languageView.isHidden = true
        self.shareView.isHidden = false
        self.exportView.isHidden = true

        self.setupLanguage()
        
        if AppUser.isLogin() {
            self.signinBtn.isHidden = true
            self.signupBtn.isHidden = true
        } else {
            self.signinBtn.isHidden = false
            self.signupBtn.isHidden = false
        }
    }
    
    private func setupLanguage() {
        print(AppLanguage.currentAppleLanguage())
        if AppConstants.getLanguage() == "English" {
            englishCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
            arabicCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
        } else {
            englishCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
            arabicCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
        }
    }
    
    // MARK : Button Actions
    
    @IBAction func signUpTapped(_ sender: Any) {
        if !AppUser.isLogin() {
            delegate?.didSelectMenu(index: 5)
        }
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        if !AppUser.isLogin() {
            delegate?.didSelectMenu(index: 6)
        }
    }
    
    @IBAction func engLangTapped(_ sender: Any) {
        englishCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
        arabicCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
        delegate?.didSelectMenu(index: 9)
    }
    
    @IBAction func arabicLangTapped(_ sender: Any) {
        englishCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
        arabicCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
        delegate?.didSelectMenu(index: 10)
    }
    
    // MARK: TableView DataSource and Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        let item = menuItems[indexPath.row]
        if item.index != 0 {
            cell.ivIcon.image = UIImage(named: item.icon)
            cell.lblText.text = item.text
        } else {
            cell.ivIcon.image = nil
            cell.lblText.text = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let item = menuItems[indexPath.row]
        if item.index == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = menuItems[indexPath.row]
        if item.index != 0 && item.index != 2 {
            delegate?.didSelectMenu(index: item.index)
        }
        if item.index == 2 {
            self.tableView.isHidden = true
            self.languageView.isHidden = false
            self.shareView.isHidden = true
            self.exportView.isHidden = true
        }
    }
}
