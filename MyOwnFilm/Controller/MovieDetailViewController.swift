//
//  MovieDetailViewController.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/06.
//

import UIKit

class MovieDetailViewController: CommonViewController {

    @IBOutlet weak var backgroundmovieImage: UIImageView!
    
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var index: Int?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MemoViewController {
            vc.index = index
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 백그라운드, 텍스트, 버튼 컬러 변경
        view.backgroundColor = .black
        
        [storyLabel, titleLabel, dateLabel].forEach { $0?.textColor = .white }
        
        
        if let index = index {
            MovieDataSource.shared.loadImage(from: MovieDataSource.shared.nowPlayingMovieList[index].posterPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
                if let img = img {
                    self.backgroundmovieImage.image = img
                } else {
                    self.backgroundmovieImage.image = UIImage(named: "Default Image")
                }
            }
            
            
            let movieData = MovieDataSource.shared.nowPlayingMovieList[index]
            storyLabel.text = movieData.overviewStr
            titleLabel.text = movieData.titleStr
            dateLabel.text = movieData.releaseDate
        }
    }
}



