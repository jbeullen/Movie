//
//  Constants.swift
//  MovieBrowser
//
//  Created by Jeroen Beullens on 23/07/18.
//  Copyright © 2018 Jeroen Beullens. All rights reserved.
//

import Foundation

import Foundation
import AWSCore
import AWSAppSync

// AppSync CONFIGURATION
// The API Key for authorization
let StaticAPIKey = "<YOUR API KEY>"
// The Endpoint URL for AppSync
let AppSyncEndpointURL: URL = URL(string: "<APPSYNC ENDPOINT>")!
// AWS Region of your AppSync API
let AppSyncRegion: AWSRegionType = .EUWest1
// SQLite Database name
let database_name = "movie-app-db"


class APIKeyAuthProvider: AWSAPIKeyAuthProvider {
    func getAPIKey() -> String {
        // This function could dynamicall fetch the API Key if required and return it to AppSync client.
        return StaticAPIKey
    }
}
