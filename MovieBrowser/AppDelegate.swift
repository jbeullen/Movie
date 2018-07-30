//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Jeroen Beullens on 18/07/18.
//  Copyright © 2018 Jeroen Beullens. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables
    var window: UIWindow?
    var dataLayer: DataLayer?

    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        dataLayer = AppSyncDataLayer()
        return true
    }
}

