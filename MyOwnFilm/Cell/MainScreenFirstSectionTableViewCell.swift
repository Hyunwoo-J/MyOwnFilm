//
//  MainScreenFirstSectionTableViewCell.swift
//  MainScreenFirstSectionTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewCell: MainScreenFirstSectionCollectionViewCell?, index: Int, didTappedInTableViewCell: MainScreenFirstSectionTableViewCell)
}

class MainScreenFirstSectionTableViewCell: UITableViewCell {

    weak var cellDelegate: CollectionViewCellDelegate?
    
    @IBOutlet weak var firstSectionCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 백그라운드 컬러 변경
        backgroundColor = .black
        firstSectionCollectionView.backgroundColor = .black
        
        firstSectionCollectionView.dataSource = self
        firstSectionCollectionView.delegate = self
    }
    
    
    /// <#Description#>
    /// - Parameter movieData: MainScreenViewController에서 받을 영화 데이터 배열
    func configure(with movieData: [MovieData.Results]) {
        firstSectionCollectionView.reloadData()
    }
}




extension MainScreenFirstSectionTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenFirstSectionCollectionViewCell", for: indexPath) as! MainScreenFirstSectionCollectionViewCell
        
        self.cellDelegate?.collectionView(collectionviewCell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieDataSource.shared.nowPlayingMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenFirstSectionCollectionViewCell", for: indexPath) as! MainScreenFirstSectionCollectionViewCell
        
        let movieList = MovieDataSource.shared.nowPlayingMovieList
        let moviePosterPath = movieList[indexPath.item].posterPath
        
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
        let width = contentView.frame.size.width
        let height = (width / 2) * 3


        return CGSize(width: width, height: height)
//        return collectionView.frame.size
    }
}
