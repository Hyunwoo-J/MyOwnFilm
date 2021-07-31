//
//  MainScreenFirstSectionCollectionViewCell.swift
//  MainScreenFirstSectionCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

class MainScreenFirstSectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstSectionImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    func configure(with movieData: MovieData.Results) {
        movieTitleLabel.text = movieData.titleStr
        releaseDateLabel.text = movieData.releaseDate
    }
    
    override func awakeFromNib() {
        backgroundColor = .black
        
        firstSectionImage.layer.cornerRadius = 16
    }
}
