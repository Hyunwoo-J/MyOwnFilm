//
//  SearchMovieTableViewCell.swift
//  SearchMovieTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/31.
//

import UIKit

class SearchMovieTableViewCell: UITableViewCell {
    /// 영화 포스터를 넣을 이미지뷰
    @IBOutlet weak var movieImageView: UIImageView!
    /// 영화 제목을 넣을 레이블
    @IBOutlet weak var titleLabel: UILabel!
    /// 개봉 일자를 넣을 레이블
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    /// 공간을 나누기 위해 추가한 뷰
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter movieData: SearchMovieTableViewCell에서 받을 영화 데이터
    func configure(with movieData: MovieData.Results) {
        titleLabel.text = movieData.titleStr
        releaseDateLabel.text = movieData.releaseDate
        
        MovieImageSource.shared.loadImage(from: movieData.posterPath, posterImageSize: PosterImageSize.w342.rawValue) { img in
            if let img = img {
                self.movieImageView.image = img
            } else {
                self.movieImageView.image = UIImage(named: "Default Image")
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        /// 백그라운드 색상 설정
        backgroundColor = .black
        [firstView, secondView].forEach { $0?.backgroundColor = .clear }
        
        /// 텍스트 색상 설정
        [titleLabel, releaseDateLabel, directorLabel, actorLabel].forEach {
            $0?.textColor = .white
        }
    }
}

