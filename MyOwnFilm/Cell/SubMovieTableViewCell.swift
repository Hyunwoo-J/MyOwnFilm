//
//  SubMovieTableViewCell.swift
//  SubMovieTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/25.
//

import UIKit


/// SubScreenTableViewCell 안에 있는 CollectionViewCell과 관련된 델리게이트 프로토콜
protocol SubCollectionViewCellDelegate: AnyObject {
    /// 컬렉션뷰 셀의 인덱스를 MainScreenViewController에 전달해줍니다.
    func collectionView(collectionviewCell: SubMovieCollectionViewCell?, index: Int, didTappedInTableViewCell: SubMovieTableViewCell)
}



/// 분류별 영화 목록 컬렉션뷰를 포함한 셀
class SubMovieTableViewCell: UITableViewCell {
    
    /// 영화 분류 레이블
    @IBOutlet weak var movieClassificationLabel: UILabel!
    
    /// 분류별 영화 목록 컬렉션뷰
    @IBOutlet weak var subMovieCollectionView: UICollectionView!
    
    /// CollectionViewCellDelegate 변수
    weak var cellDelegate: SubCollectionViewCellDelegate?
    
    /// 영화 데이터 목록
    var movieList: [MovieData.Result]?
    
    
    /// 테이블뷰셀에 표시할 내용을 설정합니다.
    /// - Parameters:
    ///   - movieData: 영화 데이터 객체
    ///   - text: 영화 분류 텍스트(ex. 인기작, 액션)
    func configure(with movieData: [MovieData.Result], text: String) {
        movieClassificationLabel.text = text
        movieList = movieData
        subMovieCollectionView.reloadData()
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subMovieCollectionView.dataSource = self
        subMovieCollectionView.delegate = self
    }
}



/// 분류별 영화 목록 컬렉션뷰 데이터 관리
extension SubMovieTableViewCell: UICollectionViewDataSource {
    
    /// 섹션의 아이템 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 분류별 영화 목록 컬렉션뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 아이템 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movieList = movieList else { return 0 }
        
        return movieList.count
    }
    
    
    /// 다운로드한 이미지로 셀을 구성합니다.
    /// - Parameters:
    ///   - collectionView: 분류별 영화 목록 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 구성한 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubMovieCollectionViewCell", for: indexPath) as! SubMovieCollectionViewCell
        
        guard let movieList = movieList else { return UICollectionViewCell() }
        let posterPath = movieList[indexPath.item].posterPath
        
        cell.subMovieImageView.isHidden = true
        
        MovieImageManager.shared.loadImage(from: posterPath, posterImageSize: PosterImageSize.w342.rawValue) { img in
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



/// 분류별 영화 목록 컬렉션뷰의 탭 이벤트 처리
extension SubMovieTableViewCell: UICollectionViewDelegate {
    
    
    /// 셀을 탭하면 셀의 인덱스를 대리자에게 전달합니다.
    /// - Parameters:
    ///   - collectionView: 분류별 영화 목록 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubMovieCollectionViewCell", for: indexPath) as! SubMovieCollectionViewCell
        
        cellDelegate?.collectionView(collectionviewCell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
}
