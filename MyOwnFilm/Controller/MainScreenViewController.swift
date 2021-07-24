//
//  MainScreenViewController.swift
//  MainScreenViewController
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

class MainScreenViewController: CommonViewController {

    @IBOutlet weak var firstSectionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Date().releaseDate)
        
        MovieDataSource.shared.fetchNowPlayingMovie(by: Date().releaseDate) {
            
            self.firstSectionTableView.reloadData()
        }
    }

}




extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainScreenFirstSectionTableViewCell", for: indexPath) as! MainScreenFirstSectionTableViewCell
        
        let target = MovieDataSource.shared.nowPlayingMovieList
        cell.configure(with: target)
        
        
        return cell
    }
}
