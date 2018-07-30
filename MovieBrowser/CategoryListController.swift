//
//  MasterViewController.swift
//  MovieBrowser
//
//  Created by Jeroen Beullens on 18/07/18.
//  Copyright © 2018 Jeroen Beullens. All rights reserved.
//

import UIKit

class CategoryListController: UIViewController {
    // MARK: - Variables
    var dataLayer: DataLayer?
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CategoryListController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .gray
        
        return refreshControl
    }()

    var categoryList: [MovieCategory] = [] {
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
        dataLayer = appDelegate.dataLayer
        
        loadAllCategories()
        
        tableView.refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Data Fetching
    func loadAllCategories() {
        loadCategoriesFromDataLayer(dataRetrieval: .fromServer)
    }
    
    func loadAllCategoriesFromCache() {
        loadCategoriesFromDataLayer(dataRetrieval: .fromCache)
    }
    
    private func loadCategoriesFromDataLayer(dataRetrieval: DataRetrieval){
        if let dataLayer = self.dataLayer{
            dataLayer.listMovieCategories(dataRetrieval: dataRetrieval) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let result  =  result {
                    self.categoryList = result
                }
            }
        }
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadAllCategories()
        refreshControl.endRefreshing()
    }

   // MARK: - Navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "ShowCategory",
            let destination = segue.destination as? CategoryOverviewController,
            let rowIndex = tableView.indexPathForSelectedRow?.row
       {
            destination.category = self.categoryList[rowIndex]
       }
   }

}

// MARK: - UITableViewDataSource
extension CategoryListController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let textLabel = cell.textLabel{
            textLabel.text = categoryList[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

