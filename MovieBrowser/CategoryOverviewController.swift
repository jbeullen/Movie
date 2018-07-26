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
    var category: MovieCategory? {
        didSet{
            if let categoryName = category?.title {
                self.navigationItem.title = categoryName
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
