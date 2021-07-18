//
//  ViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/05/29.
//

import UIKit

class TableViewController: CommonViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    var downloadedMovies = [MovieModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.dataSource = self
        
        // self로 접근해서 호출
        // self.alertFunc(title: <#T##String#>, message: <#T##String#>, actionTitle: <#T##String#>, actionStyle: <#T##UIAlertAction.Style#>)
    }    
}
