//
//  StorageCollectionViewCell.swift
//  StorageCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import UIKit


/// 보관함 화면 셀
class StorageCollectionViewCell: UICollectionViewCell {
    
    /// 영화 본 날짜 레이블
    @IBOutlet weak var viewingDateLabel: UILabel!
    
    /// 본 장소 레이블
    @IBOutlet weak var placeLabel: UILabel!
    
    /// 영화 이미지뷰
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    /// 컬렉션뷰셀에 표시할 내용을 설정합니다.
    ///
    /// 영화 본 날짜와 본 장소, 영화 이미지를 표시합니다.
    /// - Parameter movieData: 영화 데이터 객체
    func configure(with movieData: ReviewList.Review) {
        viewingDateLabel.text = movieData.viewingDate.toManagerDBDate()?.toUserDateString()
        placeLabel.text = movieData.movieTheater
        
        guard let posterPath = movieData.posterPath else { return }
        
        MovieImageManager.shared.loadImage(from: posterPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
            if let img = img {
                self.movieImageView.image = img
            } else {
                self.movieImageView.image = UIImage(named: DefaultImageName.defaultImage.rawValue)
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 뷰의 외곽선을 깎습니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.layer.cornerRadius = 6
    }
}
