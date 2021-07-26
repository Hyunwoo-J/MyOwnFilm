//
//  MainScreenViewController.swift
//  MainScreenViewController
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

class MainScreenViewController: CommonViewController {

    @IBOutlet weak var mainScreenTableView: UITableView!
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let cell = sender as? UITableViewCell, let indexPath = MainScreenTableView.indexPath(for: cell) {
//            if let vc = segue.destination as? MovieDetailViewController {
//                vc.index = index
//            }
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백그라운드 컬러 변경
        view.backgroundColor = .black
        mainScreenTableView.backgroundColor = .black
        
        print(Date().releaseDate)
        
        MovieDataSource.shared.fetchMovie(by: Date().releaseDate) {
            self.mainScreenTableView.reloadData()
        }
        
        
        
    }
    
    
}



extension MainScreenViewController: CollectionViewCellDelegate {
    func collectionView(collectionviewCell: MainScreenFirstSectionCollectionViewCell?, index: Int, didTappedInTableViewCell: MainScreenFirstSectionTableViewCell) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.index = index
            
            show(vc, sender: nil)
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
            
            cell.cellDelegate = self
            
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
