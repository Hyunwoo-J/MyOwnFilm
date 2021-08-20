//
//  SubMovieCollectionViewCell.swift
//  SubMovieCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/07/25.
//

import UIKit

class SubMovieCollectionViewCell: UICollectionViewCell {
    /// 영화 포스터를 넣을 이미지뷰
    @IBOutlet weak var subMovieImageView: UIImageView!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        /// 백그라운드 색상 설정
        backgroundColor = .black
        /// 뷰 외곽선 깎기
        layer.cornerRadius = 6
    }
}
