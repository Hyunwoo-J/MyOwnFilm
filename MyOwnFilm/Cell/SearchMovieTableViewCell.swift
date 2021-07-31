//
//  SearchMovieTableViewCell.swift
//  SearchMovieTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/31.
//

import UIKit

class SearchMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var actor: UILabel!
    
    // 공간을 나누기 위해 추가한 뷰
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    
    func configure(with movieData: MovieData.Results) {
        title.text = movieData.titleStr
        releaseDate.text = movieData.releaseDate
        
        
        MovieDataSource.shared.loadImage(from: movieData.posterPath, posterImageSize: PosterImageSize.w342.rawValue) { img in
            if let img = img {
                self.movieImage.image = img
            } else {
                self.movieImage.image = UIImage(named: "Default Image")
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
        firstView.backgroundColor = .clear
        secondView.backgroundColor = .clear
        
        [title, releaseDate, director, actor].forEach {
            $0?.textColor = .white
        }
    }
    
    
}

