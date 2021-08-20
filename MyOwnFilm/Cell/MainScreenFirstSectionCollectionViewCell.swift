//
//  MainScreenFirstSectionCollectionViewCell.swift
//  MainScreenFirstSectionCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

class MainScreenFirstSectionCollectionViewCell: UICollectionViewCell {
    /// 영화 포스터를 넣을 이미지뷰
    @IBOutlet weak var firstSectionImageView: UIImageView!
    /// 영화 제목을 넣을 레이블
    @IBOutlet weak var movieTitleLabel: UILabel!
    /// 개봉 일자를 넣을 레이블
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    /// 컬렉션뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter movieData: MainScreenFirstSectionTableViewCell에서 받을 영화 데이터 배열
    func configure(with movieData: MovieData.Results) {
        movieTitleLabel.text = movieData.titleStr
        releaseDateLabel.text = movieData.releaseDate
    }
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        /// 백그라운드 색상 설정
        backgroundColor = .black
        /// 뷰 외곽선 깎기
        firstSectionImageView.layer.cornerRadius = 16
    }
}
