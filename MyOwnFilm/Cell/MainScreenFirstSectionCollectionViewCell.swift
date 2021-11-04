//
//  MainScreenFirstSectionCollectionViewCell.swift
//  MainScreenFirstSectionCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit


/// 현재 상영중인 영화 목록 셀
class MainScreenFirstSectionCollectionViewCell: UICollectionViewCell {
    
    /// 영화 포스터 이미지뷰
    @IBOutlet weak var firstSectionImageView: UIImageView!
    
    /// 영화 제목 레이블
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    /// 개봉일 레이블
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    /// 컬렉션뷰셀에 표시할 내용을 설정합니다.
    ///
    /// 영화 제목과 개봉일을 표시합니다.
    /// - Parameter movieData: 영화 데이터 객체
    func configure(with movieData: MovieData.Result) {
        movieTitleLabel.text = movieData.titleStr
        releaseDateLabel.text = movieData.releaseDate.toManagerDate()?.toUserDateStringForMovieData()
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 뷰 외곽선을 깎습니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstSectionImageView.layer.cornerRadius = 16
    }
}
