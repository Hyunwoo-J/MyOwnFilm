//
//  MainScreenViewController.swift
//  MainScreenViewController
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

class MainScreenViewController: CommonViewController {

    @IBOutlet weak var MainScreenTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Date().releaseDate)
        
        MovieDataSource.shared.fetchNowPlayingMovie(by: Date().releaseDate) {
            
            self.MainScreenTableView.reloadData()
        }
        
        MovieDataSource.shared.fetchPopularMovie(by: Date().releaseDate) {
            
            self.MainScreenTableView.reloadData()
        }
        
        MovieDataSource.shared.fetchActionMovie(by: Date().releaseDate) {
            
            self.MainScreenTableView.reloadData()
        }
    }
}




extension MainScreenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainScreenFirstSectionTableViewCell", for: indexPath) as! MainScreenFirstSectionTableViewCell
            
            let target = MovieDataSource.shared.nowPlayingMovieList
            cell.configure(with: target)
            
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubMovieTableViewCell", for: indexPath) as! SubMovieTableViewCell
            
            switch indexPath.row {
            case 0:
                let target = MovieDataSource.shared.popularMovieList
                cell.configure(with: target, text: "인기작")
                
                return cell
                
            case 1:
                let target = MovieDataSource.shared.actionMoveList
                cell.configure(with: target, text: "액션")
                
                return cell
                
            default:
                fatalError()
            }
            
        default:
            fatalError()
        }
        
    }
}
