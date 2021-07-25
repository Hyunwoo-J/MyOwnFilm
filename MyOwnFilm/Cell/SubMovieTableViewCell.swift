//
//  SubMovieTableViewCell.swift
//  SubMovieTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/25.
//

import UIKit

class SubMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieClassificationLabel: UILabel!
    @IBOutlet weak var subMovieCollectionView: UICollectionView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subMovieCollectionView.dataSource = self
    }
    
    func configure(with movieData: [MovieData.Results], text: String) {
        
        movieClassificationLabel.text = text
        subMovieCollectionView.reloadData()
    }
}




extension SubMovieTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieDataSource.shared.popularMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubMovieCollectionViewCell", for: indexPath) as! SubMovieCollectionViewCell
        
        
        let movieList = MovieDataSource.shared.popularMovieList
        let moviePosterPath = movieList[indexPath.item].poster_path
        
        MovieDataSource.shared.loadImage(from: moviePosterPath, posterImageSize: PosterImageSize.w342.rawValue) { img in
            if let img = img {
                cell.subMovieImage.image = img
            } else {
                cell.subMovieImage.image = UIImage(named: "Default Image")
            }
        }
        
        return cell
    }
}
