//
//  StorageCollectionViewCell.swift
//  StorageCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import UIKit


/// 보관함 화면 컬렉션뷰 셀
class StorageCollectionViewCell: UICollectionViewCell {
    /// 날짜를 넣을 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 본 장소를 넣을 레이블
    @IBOutlet weak var placeLabel: UILabel!
    
    /// 영화 이미지를 넣을 이미지뷰
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    /// 컬렉션뷰셀에 표시할 내용을 설정합니다.
    /// - Parameter movieData: StorageCollectionViewCell에서 받을 영화 데이터
    func configure(with movieData: ReviewListResponse.Review) {
        dateLabel.text = movieData.viewingDate.toManagerDBDate()?.toUserDateString()
        placeLabel.text = movieData.movieTheater
        
        guard let posterPath = movieData.posterPath else { return }
        
        MovieImageSource.shared.loadImage(from: posterPath, posterImageSize: PosterImageSize.w780.rawValue) { img in
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
        
        movieImageView.layer.cornerRadius = 6
        [dateLabel, placeLabel].forEach { $0?.textColor = .white }
    }
}
