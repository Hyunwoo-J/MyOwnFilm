//
//  MainScreenViewController.swift
//  MainScreenViewController
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

class MainScreenViewController: CommonViewController {
    
    @IBOutlet weak var mainScreenTableView: UITableView!
    
    // 영화 구분 타이틀
    let titleList = ["인기작", "액션", "코미디", "로맨스", "판타지"]
    
    
    /// 상태바를 흰색으로 바꾸기 위해 추가한 메소드
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
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
            
            let nowPlayingData = MovieDataSource.shared.nowPlayingMovieList[index]
            MovieDataSource.shared.loadImage(from: nowPlayingData.posterPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                vc.image = img
            }
            
            vc.movieData = MovieDataSource.shared.nowPlayingMovieList
            
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
            
            return MovieDataSource.shared.movieLists.count
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
                
                let target = MovieDataSource.shared.movieLists[indexPath.row]
                cell.configure(with: target, text: titleList[indexPath.row])
                
                return cell
                
            default:
                fatalError()
            }
            
        }
    }
