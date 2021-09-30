//
//  SubMovieTableViewCell.swift
//  SubMovieTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/25.
//

import UIKit


/// SubScreenTableViewCell 안에 있는 CollectionViewCell과 관련된 델리게이트 프로토콜
protocol SubCollectionViewCellDelegate: AnyObject {
    /// 컬렉션뷰 셀의 인덱스를 MainScreenViewController에 전달해줄 메소드
    func collectionView(collectionviewCell: SubMovieCollectionViewCell?, index: Int, didTappedInTableViewCell: SubMovieTableViewCell)
}



/// 두번째 섹션 테이블뷰 셀
class SubMovieTableViewCell: UITableViewCell {
    
    /// 영화 분류 텍스트를 넣을 레이블
    @IBOutlet weak var movieClassificationLabel: UILabel!
    
    /// 두번째 섹션의 컬렉션뷰
    @IBOutlet weak var subMovieCollectionView: UICollectionView!
    
    /// CollectionViewCellDelegate 변수
    weak var cellDelegate: SubCollectionViewCellDelegate?
    
    /// 영화 데이터 배열을 받을 변수
    var movie: [MovieData.Result]?
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameters:
    ///   - movieData: SubMovieTableViewCell에서 받을 영화 데이터 배열
    ///   - text: 영화 분류 텍스트(ex. 인기작, 액션)
    func configure(with movieData: [MovieData.Result], text: String) {
        movieClassificationLabel.text = text
        movie = movieData
        subMovieCollectionView.reloadData()
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        // 백그라운드 색상 설정
        backgroundColor = .black
        subMovieCollectionView.backgroundColor = .black
        
        subMovieCollectionView.dataSource = self
        subMovieCollectionView.delegate = self
    }
}



extension SubMovieTableViewCell: UICollectionViewDataSource {
    /// 데이터소스 객체에게 지정된 섹션에 아이템 수를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - section: 컬렉션뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션 아이템의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movie = movie else { return 0 }
        
        return movie.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubMovieCollectionViewCell", for: indexPath) as! SubMovieCollectionViewCell
        
        guard let movie = movie else { return UICollectionViewCell() }
        let posterPath = movie[indexPath.item].posterPath
        
        cell.subMovieImageView.isHidden = true
        
        MovieImageSource.shared.loadImage(from: posterPath, posterImageSize: PosterImageSize.w342.rawValue) { img in
            if let img = img {
                cell.subMovieImageView.image = img
                cell.subMovieImageView.isHidden = false
            } else {
                cell.subMovieImageView.image = UIImage(named: "Default Image")
            }
        }
        
        return cell
    }
}



extension SubMovieTableViewCell: UICollectionViewDelegate {
    /// - Parameters: 델리게이트에게 셀이 선택되었음을 알립니다.
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - indexPath: 선택한 셀의 IndexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubMovieCollectionViewCell", for: indexPath) as! SubMovieCollectionViewCell
        
        cellDelegate?.collectionView(collectionviewCell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
}
