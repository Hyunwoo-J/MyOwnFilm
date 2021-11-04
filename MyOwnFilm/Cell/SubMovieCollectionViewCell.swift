//
//  SubMovieCollectionViewCell.swift
//  SubMovieCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/07/25.
//

import UIKit


/// 분류별 영화 목록 셀
class SubMovieCollectionViewCell: UICollectionViewCell {
    
    /// 영화 포스터 이미지뷰
    @IBOutlet weak var subMovieImageView: UIImageView!
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 뷰 외곽선을 깎습니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 6
    }
}
