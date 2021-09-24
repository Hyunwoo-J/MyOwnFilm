//
//  StorageCollectionViewCell.swift
//  StorageCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import UIKit

class StorageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        movieImageView.layer.cornerRadius = 6
        containerView.backgroundColor = .darkGray
        [dateLabel, placeLabel].forEach { $0?.textColor = .white }
    }
    
    
    func configure(with movieData: MovieReview) {
        dateLabel.text = movieData.date.toUserDateString()
        placeLabel.text = movieData.place
        
        MovieImageSource.shared.loadImage(from: movieData.posterPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
            if let img = img {
                self.movieImageView.image = img
            } else {
                self.movieImageView.image = UIImage(named: "Default Image")
            }
        }
    }
}
