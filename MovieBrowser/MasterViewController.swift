//
//  MasterViewController.swift
//  MovieBrowser
//
//  Created by Jeroen Beullens on 18/07/18.
//  Copyright © 2018 Jeroen Beullens. All rights reserved.
//

import UIKit
import AWSAppSync

class MasterViewController: UITableViewController {
    var appSyncClient: AWSAppSyncClient?

    var categoryList: [ListCategoriesQuery.Data.ListCategory.Item?]? = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func loadAllCategories() {
        appSyncClient?.fetch(query: ListCategoriesQuery(), cachePolicy: .returnCacheDataAndFetch)  { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            self.categoryList = result?.data?.listCategories?.items
        }
    }
    
    func loadAllCategoriesFromCache() {
        
        appSyncClient?.fetch(query: ListCategoriesQuery(), cachePolicy: .returnCacheDataDontFetch)  { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            self.categoryList = result?.data?.listCategories?.items
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        loadAllCategoriesFromCache()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        
        loadAllCategories()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = categoryList?[indexPath.row]
        cell.textLabel!.text = object?.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}

