//
//  DataLayer.swift
//  MovieBrowser
//
//  Created by Jeroen Beullens on 25/07/18.
//  Copyright © 2018 Jeroen Beullens. All rights reserved.
//

import Foundation
import AWSAppSync

struct MovieCategory {
    var id = ""
    var title = ""
}

enum DataRetrieval {
    case fromServer, fromCache

}
protocol DataLayer {
    func listMovieCategories(dataRetrieval: DataRetrieval, completion: @escaping (_ result: [MovieCategory]?,_ error: Error?) -> Void )
}

class DummyDataLayer: DataLayer {
    private func generateMovieCategories(length: Int) -> [MovieCategory] {
        var array = [MovieCategory]()
        
        for i in 1...length {
            array.append(MovieCategory(id: UUID().uuidString, title: "Category \(i)"))
        }
        
        return array
    }

    func listMovieCategories(dataRetrieval: DataRetrieval, completion: @escaping (_ result: [MovieCategory]?,_ error: Error?) -> Void ) {
        completion(generateMovieCategories(length: 10), nil)
    }
}


class AppSyncDataLayer: DataLayer {
    private var appSyncClient: AWSAppSyncClient?

    init(){
        
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
    }
    
    private func convert(_ dataRetrieval: DataRetrieval) -> CachePolicy {
        switch dataRetrieval {
            case .fromCache:
                return .returnCacheDataDontFetch
        
            case .fromServer:
                return .returnCacheDataAndFetch
        }
    }
    
    func listMovieCategories(dataRetrieval: DataRetrieval, completion: @escaping (_ result: [MovieCategory]?,_ error: Error?) -> Void ) {
        
        if let appSyncClient = self.appSyncClient{
            
            
            appSyncClient.fetch(query: ListCategoriesQuery(), cachePolicy: convert(dataRetrieval))  { (result, error) in
                if let error = error {
                    completion(nil, error)
                }
                
                if let items  =  result?.data?.listCategories?.items {
                    let categories = items.map{ MovieCategory(id: $0!.id, title: $0!.title) }
                    completion(categories, nil)
                }
            }
        }
        
    }
}
