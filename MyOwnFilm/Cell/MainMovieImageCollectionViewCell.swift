//
//  MainMovieImageCollectionViewCell.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/17.
//

import UIKit

class MainMovieImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieName: UILabel!
    
    func configure(with movieData: MovieData.Results) {
        
        movieName.text = movieData.title
        
//        MovieDataSource.shared.loadImage(from: movieData.poster_path) { img in
//            if let img = img {
//                self.movieImageView.image = img
//            } else {
//                self.movieImageView.image = UIImage(named: "Default Image")
//            }
//        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.layer.cornerRadius = 20

    }
    
}
