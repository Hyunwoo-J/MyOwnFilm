//
//  SubMovieCollectionViewCell.swift
//  SubMovieCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/07/25.
//

import UIKit


/// 두번째 섹션 테이블뷰셀 안에 들어가는 컬렉션뷰 셀
class SubMovieCollectionViewCell: UICollectionViewCell {
    /// 영화 포스터를 넣을 이미지뷰
    @IBOutlet weak var subMovieImageView: UIImageView!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 뷰 외곽선 깎기
        layer.cornerRadius = 6
    }
}
