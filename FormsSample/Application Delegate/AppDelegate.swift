//
//  AppDelegate.swift
//  FormsSample
//
//  Created by Chris Eidhof on 22.03.18.
//  Copyright © 2018 objc.io. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let navigationController = UINavigationController()
    let driver = FormDriver(initial: Hotspot(), build: hotspotForm)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = navigationController
        navigationController.viewControllers = [
            driver.formViewController
        ]
        window?.makeKeyAndVisible()
        return true
    }
}
