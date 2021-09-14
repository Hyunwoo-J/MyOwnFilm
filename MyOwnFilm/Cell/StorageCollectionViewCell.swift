//
//  StorageCollectionViewCell.swift
//  StorageCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import UIKit

class StorageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        layer.cornerRadius = 6
    }
    
    
    func configure(with movieData: MovieReview) {
        MovieImageSource.shared.loadImage(from: movieData.posterPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
            if let img = img {
                self.movieImageView.image = img
            } else {
                self.movieImageView.image = UIImage(named: "Default Image")
            }
        }
    }
}
