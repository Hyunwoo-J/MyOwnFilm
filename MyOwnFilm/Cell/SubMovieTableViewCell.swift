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
    
    var movie: [MovieData.Results]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 백그라운드 컬러 변경
        backgroundColor = .black
        subMovieCollectionView.backgroundColor = .black
        
        subMovieCollectionView.dataSource = self
    }
    
    func configure(with movieData: [MovieData.Results], text: String) {
        
        movieClassificationLabel.text = text
        movie = movieData
        subMovieCollectionView.reloadData()
    }
}




extension SubMovieTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movie = movie else { return 0 }
        
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubMovieCollectionViewCell", for: indexPath) as! SubMovieCollectionViewCell
        
        guard let movie = movie else { return UICollectionViewCell() }
        let movieList = movie[indexPath.row].posterPath
        let moviePosterPath = movieList
        
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
