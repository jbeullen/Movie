//
//  CategoryOverviewController.swift
//  MovieBrowser
//
//  Created by Jeroen Beullens on 25/07/18.
//  Copyright © 2018 Jeroen Beullens. All rights reserved.
//

import UIKit

class CategoryOverviewController: UIViewController {

    // MARK: - Variables
    var dataLayer: DataLayer?
    var category: MovieCategory? {
        didSet{
            if let categoryName = category?.title {
                self.navigationItem.title = categoryName
            }
        }
    }
    
    var movies: [MovieResult] = []{
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CategoryOverviewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .gray
        
        return refreshControl
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMoviesInCategoryFromCache()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataLayer = appDelegate.dataLayer
        
        loadAllMoviesInCategory()
        
         tableView.refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data Fetching
    func loadAllMoviesInCategory() {
        loadMoviesInCategoryFromDataLayer(dataRetrieval: .fromServer)
    }
    
    func loadMoviesInCategoryFromCache() {
        loadMoviesInCategoryFromDataLayer(dataRetrieval: .fromCache)
    }
    
    private func loadMoviesInCategoryFromDataLayer(dataRetrieval: DataRetrieval){
        if let dataLayer = self.dataLayer, let categoryId = self.category?.id{
            dataLayer.listMoviesInCategorie(categoryId: categoryId, dataRetrieval: dataRetrieval) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let result  =  result {
                    self.movies = result
                }
            }
        }
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadAllMoviesInCategory()
        refreshControl.endRefreshing()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension CategoryOverviewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let textLabel = cell.textLabel{
            textLabel.text = movies[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
