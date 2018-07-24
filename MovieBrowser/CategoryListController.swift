//
//  MasterViewController.swift
//  MovieBrowser
//
//  Created by Jeroen Beullens on 18/07/18.
//  Copyright © 2018 Jeroen Beullens. All rights reserved.
//

import UIKit
import AWSAppSync

class CategoryListController: UIViewController {
    // MARK: - Variables
    var appSyncClient: AWSAppSyncClient?
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CategoryListController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .gray
        
        return refreshControl
    }()

    var categoryList: [ListCategoriesQuery.Data.ListCategory.Item?] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllCategoriesFromCache()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        
        loadAllCategories()
        
        tableView.refreshControl = refresher
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Data Fetching
    func loadAllCategories() {
        loadCategoriesFromAppSync(cachePolicy: .returnCacheDataAndFetch)
    }
    
    func loadAllCategoriesFromCache() {
        loadCategoriesFromAppSync(cachePolicy: .returnCacheDataDontFetch)
    }
    
    func loadCategoriesFromAppSync(cachePolicy: CachePolicy){
        if let appSyncClient = self.appSyncClient{
            appSyncClient.fetch(query: ListCategoriesQuery(), cachePolicy: cachePolicy)  { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let items  =  result?.data?.listCategories?.items {
                    self.categoryList = items
                }
            }
        }
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadAllCategories()
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension CategoryListController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let title = categoryList[indexPath.row]?.title, let textLabel = cell.textLabel{
            textLabel.text = title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

