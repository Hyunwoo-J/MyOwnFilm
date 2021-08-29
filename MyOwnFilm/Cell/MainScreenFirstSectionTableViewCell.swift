//
//  MainScreenFirstSectionTableViewCell.swift
//  MainScreenFirstSectionTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    /// 컬렉션뷰 셀의 인덱스를 MainScreenViewController에 전달해줄 메소드
    func collectionView(collectionviewCell: MainScreenFirstSectionCollectionViewCell?, index: Int, didTappedInTableViewCell: MainScreenFirstSectionTableViewCell)
}




class MainScreenFirstSectionTableViewCell: UITableViewCell {
    weak var cellDelegate: CollectionViewCellDelegate?
    /// 첫번째 섹션의 컬렉션뷰
    @IBOutlet weak var firstSectionCollectionView: UICollectionView!
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        /// 백그라운드 색상 설정
        backgroundColor = .black
        firstSectionCollectionView.backgroundColor = .black
        
        firstSectionCollectionView.dataSource = self
        firstSectionCollectionView.delegate = self
    }
    
    
    /// 테이블뷰셀을 reload합니다.
    /// - Parameter movieData: MainScreenViewController에서 받을 영화 데이터 배열
    func configure(with movieData: [MovieData.Results]) {
        firstSectionCollectionView.reloadData()
    }
}




extension MainScreenFirstSectionTableViewCell: UICollectionViewDataSource {
    /// 데이터소스 객체에게 지정된 섹션에 아이템 수를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - section: 컬렉션뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션 아이템의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieDataSource.shared.nowPlayingMovieList.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenFirstSectionCollectionViewCell", for: indexPath) as! MainScreenFirstSectionCollectionViewCell
        
        let movieList = MovieDataSource.shared.nowPlayingMovieList
        let moviePosterPath = movieList[indexPath.item].posterPath
        
        MovieImageSource.shared.loadImage(from: moviePosterPath, posterImageSize: PosterImageSize.w500.rawValue) { img in
            if let img = img {
                cell.firstSectionImageView.image = img
            } else {
                cell.firstSectionImageView.image = UIImage(named: "Default Image")
            }
        }
        
        cell.configure(with: movieList[indexPath.item])
        
        return cell
    }
}




extension MainScreenFirstSectionTableViewCell: UICollectionViewDelegate {
    /// - Parameters: 델리게이트에게 셀이 선택되었음을 알립니다.
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - indexPath: 선택한 셀의 IndexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenFirstSectionCollectionViewCell", for: indexPath) as! MainScreenFirstSectionCollectionViewCell
        
        cellDelegate?.collectionView(collectionviewCell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
}




extension MainScreenFirstSectionTableViewCell: UICollectionViewDelegateFlowLayout {
    /// 델리게이트에게 지정된 아이템의 셀의 사이즈를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 이 메소드를 호출하는 컬렉션뷰
    ///   - collectionViewLayout: 정보를 요청하는 layout 객체
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 아이템 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = contentView.frame.size.width
        let height = (width / 2) * 3

        return CGSize(width: width, height: height)
    }
}
