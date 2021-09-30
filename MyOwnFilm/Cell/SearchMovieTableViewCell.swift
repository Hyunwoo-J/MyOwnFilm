//
//  SearchMovieTableViewCell.swift
//  SearchMovieTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/31.
//

import UIKit


/// 검색 화면 테이블뷰 셀
class SearchMovieTableViewCell: UITableViewCell {
    /// 영화 포스터를 넣을 이미지뷰
    @IBOutlet weak var movieImageView: UIImageView!
    
    /// 영화 제목을 넣을 레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 개봉 일자를 넣을 레이블
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    /// 장르를 넣을 레이블
    @IBOutlet weak var genreLabel: UILabel!
    
    /// 영화 줄거리를 넣을 레이블
    @IBOutlet weak var storyLabel: UILabel!
    
    /// 공간을 나누기 위해 추가한 뷰 중 첫번째 뷰
    @IBOutlet weak var firstView: UIView!
    
    /// 공간을 나누기 위해 추가한 뷰 중 두번째 뷰
    @IBOutlet weak var secondView: UIView!
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter movieData: SearchMovieTableViewCell에서 받을 영화 데이터
    func configure(with movieData: MovieData.Result) {
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
        
        var genreText = ""
        for genre in genreArray {
            var movieGenre = ""
            
            switch genre {
            case .action:
                movieGenre = "액션 "
            case .adventure:
                movieGenre = "모험 "
            case .animation:
                movieGenre = "애니메이션 "
            case .comedy:
                movieGenre = "코메디 "
            case .crime:
                movieGenre = "범죄 "
            case .documentary:
                movieGenre = "다큐멘터리 "
            case .drama:
                movieGenre = "드라마 "
            case .family:
                movieGenre = "가족 "
            case .fantasy:
                movieGenre = "판타지 "
            case .history:
                movieGenre = "역사 "
            case .horror:
                movieGenre = "공포 "
            case .music:
                movieGenre = "음악 "
            case .mystery:
                movieGenre = "미스터리 "
            case .romance:
                movieGenre = "로맨스 "
            case .scienceFiction:
                movieGenre = "SF "
            case .tvMovie:
                movieGenre = "TV 영화 "
            case .thriller:
                movieGenre = "스릴러 "
            case .war:
                movieGenre = "전쟁 "
            case .western:
                movieGenre = "서부 "
            }
            
            genreText.append(movieGenre)
        }
        genreLabel.text = genreText
        movieImageView.isHidden = true
        
        MovieImageSource.shared.loadImage(from: movieData.posterPath, posterImageSize: PosterImageSize.w342.rawValue) { img in
            if let img = img {
                self.movieImageView.image = img
                self.movieImageView.isHidden = false
            } else {
                self.movieImageView.image = UIImage(named: "Default Image")
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 백그라운드 색상 설정
        backgroundColor = .black
        [firstView, secondView].forEach { $0?.backgroundColor = .clear }
        
        // 텍스트 색상 설정
        [titleLabel, releaseDateLabel, genreLabel, storyLabel].forEach {
            $0?.textColor = .white
        }
    }
}

