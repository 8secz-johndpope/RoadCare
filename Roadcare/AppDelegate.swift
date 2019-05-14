//
//  AppDelegate.swift
//  Roadcare
//
//  Created by macbook on 4/6/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)

        UINavigationBar.appearance().barTintColor = ColorPalette.primary
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]

        let viewController = StartupViewController(nibName: "StartupViewController", bundle: nil)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: Show dashboard
    
    func showDashboard() {
        let home = HomeViewController(nibName: "HomeViewController", bundle: nil)
        home.tabBarItem.title = "Home"
        home.tabBarItem.image = UIImage(named: "ic_tab_home")

        let statistics = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        statistics.tabBarItem.title = "Statistics"
        statistics.tabBarItem.image = UIImage(named: "ic_shape")

        let potholes = ReportPotholeViewController(nibName: "ReportPotholeViewController", bundle: nil)
        potholes.tabBarItem.title = "Report a Pothole"
        potholes.tabBarItem.image = UIImage(named: "ic_contact")

        let login = AddUserViewController(nibName: "AddUserViewController", bundle: nil)
        login.tabBarItem.title = "Login"
        login.tabBarItem.image = UIImage(named: "ic_login")

        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [home, statistics, potholes, login]
        tabbarController.tabBar.barTintColor = UIColor.white
        tabbarController.tabBar.tintColor = ColorPalette.primary

        let navController = MainNavigationController()
        navController.viewControllers = [tabbarController]

        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
}
