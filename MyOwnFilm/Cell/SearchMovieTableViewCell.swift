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
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    
    /// 공간을 나누기 위해 추가한 뷰
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter movieData: SearchMovieTableViewCell에서 받을 영화 데이터
    func configure(with movieData: MovieData.Results) {
        titleLabel.text = movieData.titleStr
        releaseDateLabel.text = movieData.releaseDate.toManagerDate()?.toUserDateStringForMovieData()
        storyLabel.text = movieData.overviewStr
        
        var genreArray = [MovieGenre]()
        for genreId in movieData.genreIds {
            if let genre = MovieGenre(rawValue: genreId) {
                if genreArray.count < 2 {
                    genreArray.append(genre)
                }
            }
        }
        
        var str = ""
        for i in genreArray {
            var a = ""
            
            switch i {
            case .action:
                a = "액션 "
            case .adventure:
                a = "모험 "
            case .animation:
                a = "애니메이션 "
            case .comedy:
                a = "코메디 "
            case .crime:
                a = "범죄 "
            case .documentary:
                a = "다큐멘터리 "
            case .drama:
                a = "드라마 "
            case .family:
                a = "가족 "
            case .fantasy:
                a = "판타지 "
            case .history:
                a = "역사 "
            case .horror:
                a = "공포 "
            case .music:
                a = "음악 "
            case .mystery:
                a = "미스터리 "
            case .romance:
                a = "로맨스 "
            case .scienceFiction:
                a = "SF "
            case .tvMovie:
                a = "TV 영화 "
            case .thriller:
                a = "스릴러 "
            case .war:
                a = "전쟁 "
            case .western:
                a = "서부 "
            }
            
            str.append(a)
        }
        genreLabel.text = str
        
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
        [titleLabel, releaseDateLabel, genreLabel, storyLabel].forEach {
            $0?.textColor = .white
        }
    }
}

