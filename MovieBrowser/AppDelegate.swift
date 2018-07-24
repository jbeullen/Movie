//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Jeroen Beullens on 18/07/18.
//  Copyright © 2018 Jeroen Beullens. All rights reserved.
//

import UIKit
import AWSAppSync

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables
    var window: UIWindow?
    var appSyncClient: AWSAppSyncClient?


    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let databaseURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent(database_name)
        
        do {
            // initialize the AppSync client configuration configuration
            let appSyncConfig = try AWSAppSyncClientConfiguration(url: AppSyncEndpointURL,
                                                                  serviceRegion: AppSyncRegion,
                                                                  apiKeyAuthProvider: APIKeyAuthProvider(),
                                                                  databaseURL:databaseURL)
            // initialize app sync client
            appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            // set id as the cache key for objects
            appSyncClient?.apolloClient?.cacheKeyForObject = { $0["id"] }
            
        } catch {
            print("Error initializing AppSync client. \(error)")
        }
        return true
    }
}

