//
//  MainNavigationController.swift
//  Roadcare
//
//  Created by macbook on 4/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import SideMenu

class MainNavigationController: UINavigationController, MenuViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        viewController.delegate = self
        let navController = UISideMenuNavigationController(rootViewController: viewController)
        navController.menuWidth = 327
        navController.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.menuLeftNavigationController = navController
        SideMenuManager.default.menuRightNavigationController = nil
        SideMenuManager.default.menuAddPanGestureToPresent(toView: navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    // MARK: MenuViewControllerDelegate Method
    
    func didSelectMenu(index: Int) {
        dismiss(animated: true) {
            switch index {
            case 1:
                self.showCountryPage()
                break
            case 2:
                self.showLanguage()
                break
            case 3:
                self.showAddUsersPage()
                break
            case 4:
                self.showPotholesPage()
                break
            case 5:
                self.showSignupPage()
                break
            case 6:
                self.showSigninPage()
                break
            case 9:
                self.didChangeLanguage(lang: "English")
                break
            case 10:
                self.didChangeLanguage(lang: "Arabic")
                break
            default:
                break
            }
        }
    }
    
    private func showCountryPage() {
//        let viewController = ReportViewController(nibName: "ReportViewController", bundle: nil)
//        pushViewController(viewController, animated: true)
    }
    
    private func showLanguage() {
        
    }
    
    private func showAddUsersPage() {
        let viewcontroller = AddUserViewController(nibName: "AddUserViewController", bundle: nil)
        pushViewController(viewcontroller, animated: true)
    }
    
    private func showPotholesPage() {
        
    }
    
    private func showSignupPage() {
        let viewController = SignupViewController(nibName: "SignupViewController", bundle: nil)
        pushViewController(viewController, animated: true)
    }
    
    private func showSigninPage() {
        let viewController = SigninViewController(nibName: "SigninViewController", bundle: nil)
        pushViewController(viewController, animated: true)
    }
    
    private func didChangeLanguage(lang: String) {
        LocalStorage["app_language"] = lang
    }
}
