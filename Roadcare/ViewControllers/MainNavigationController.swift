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
                if AppConstants.getLanguage() != "English" {
                    self.showMessageResetApp(lang: "English")
                }
                break
            case 10:
                if AppConstants.getLanguage() != "Arabic" {
                    self.showMessageResetApp(lang: "Arabic")
                }
                break
            default:
                break
            }
        }
    }
    
    private func showCountryPage() {
        let viewController = SelectCityViewController(nibName: "SelectCityViewController", bundle: nil)
        pushViewController(viewController, animated: true)
    }
    
    private func showLanguage() {
        
    }
    
    private func showAddUsersPage() {
        let viewcontroller = AddUserViewController(nibName: "AddUserViewController", bundle: nil)
        pushViewController(viewcontroller, animated: true)
    }
    
    private func showPotholesPage() {
        let viewController = ListPotholesViewController(nibName: "ListPotholesViewController", bundle: nil)
        pushViewController(viewController, animated: true)
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
    
    func showMessageResetApp(lang: String) {
        let exitAppAlert = UIAlertController(title: "Restart is needed",
                                             message: "We need to close the app to chagne the language.\n Please reopen the app after this.",
                                             preferredStyle: .alert)
        
        let resetApp = UIAlertAction(title: "Close Now", style: .destructive) {
            (alert) -> Void in
            
            self.didChangeLanguage(lang: lang)
            if lang == "English" {
                Language.language = Language.english
            } else {
                Language.language = Language.arabic
            }

            // home button pressed programmatically - to thorw app to background
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // terminaing app in background
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                exit(EXIT_SUCCESS)
            })
        }
        
        let laterAction = UIAlertAction(title: "Later", style: .cancel) {
            (alert) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        exitAppAlert.addAction(resetApp)
        exitAppAlert.addAction(laterAction)
        present(exitAppAlert, animated: true, completion: nil)
    }
}
