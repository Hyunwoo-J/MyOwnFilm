//
//  MainScreenFirstSectionTableViewCell.swift
//  MainScreenFirstSectionTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

class MainScreenFirstSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var firstSectionCollectionView: UICollectionView!
    
    var nowPlayingMovieList = [MovieData.Results]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstSectionCollectionView.dataSource = self
        firstSectionCollectionView.delegate = self
    }
    
    
    func configure(with movieData: [MovieData.Results]) {
    
        
        firstSectionCollectionView.reloadData()
    }
}




extension MainScreenFirstSectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieDataSource.shared.nowPlayingMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenFirstSectionCollectionViewCell", for: indexPath) as! MainScreenFirstSectionCollectionViewCell
        
        let movieList = MovieDataSource.shared.nowPlayingMovieList
        let moviePosterPath = movieList[indexPath.item].poster_path
        
        MovieDataSource.shared.loadImage(from: moviePosterPath, posterImageSize: PosterImageSize.w500.rawValue) { img in
            if let img = img {
                cell.firstSectionImage.image = img
            } else {
                cell.firstSectionImage.image = UIImage(named: "Default Image")
            }
        }
        
        cell.configure(with: movieList[indexPath.item])
        
        return cell
    }
    
    
}




extension MainScreenFirstSectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
