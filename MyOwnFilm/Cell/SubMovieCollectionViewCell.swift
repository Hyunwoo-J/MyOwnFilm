//
//  SubMovieCollectionViewCell.swift
//  SubMovieCollectionViewCell
//
//  Created by Hyunwoo Jang on 2021/07/25.
//

import UIKit

class SubMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subMovieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 백그라운드 컬러 변경
        backgroundColor = .black
        
    }

}
