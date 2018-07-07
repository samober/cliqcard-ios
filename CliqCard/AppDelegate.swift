//
//  AppDelegate.swift
//  CliqCard
//
//  Created by Sam Ober on 6/13/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // register date value transformer for parsing server date time strings
        ValueTransformer.setValueTransformer(ISO8601DateValueTransformer(), forName: NSValueTransformerName.init(kPlankDateValueTransformerKey))
        
        // initialize the window
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        // check to see whether or not a user is logged in and direct
        // them to the correct screen
        if CliqCardAPI.shared.isLoggedIn() {
            self.showHomeController()
        } else {
            self.showStartController()
        }
        
        // make window visible
        window!.makeKeyAndVisible()
        
        // register for login/logout notifications
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLoginNotification(notification:)), name: .kCliqCardAPILoggedInNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLogoutNotification(notification:)), name: .kCliqCardAPILoggedOutNotification, object: nil)
        
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
        
        // unregister for notifications
        NotificationCenter.default.removeObserver(self, name: .kCliqCardAPILoggedInNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kCliqCardAPILoggedOutNotification, object: nil)
    }
    
    
    func showStartController() {
        // create a new start controller
        let startController = StartController()
        
        // create a new navigation controller
        let navigationController = UINavigationController(rootViewController: startController)
        navigationController.isNavigationBarHidden = true
        
        // set as root view controller
        window!.rootViewController = navigationController
    }
    
    func showHomeController() {
        // create a new home controller
        let homeController = HomeController()
        
        // create a new navigation controller
        let navigationController = UINavigationController(rootViewController: homeController)
        
        // set as root view controller
        window!.rootViewController = navigationController
    }
    
    
    @objc func didReceiveLoginNotification(notification: Notification) {
        self.showHomeController()
    }
    
    @objc func didReceiveLogoutNotification(notification: Notification) {
        self.showStartController()
    }


}

