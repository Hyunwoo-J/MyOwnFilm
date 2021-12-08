//
//  MainScreenFirstSectionTableViewCell.swift
//  MainScreenFirstSectionTableViewCell
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit


/// MainScreenTableViewCell 안에 있는 CollectionViewCell과 관련된 델리게이트 프로토콜
protocol CollectionViewCellDelegate: AnyObject {
    /// 컬렉션뷰 셀의 인덱스를 MainScreenViewController에 전달해줍니다.
    func collectionView(collectionviewCell: MainScreenFirstSectionCollectionViewCell?, index: Int, didTappedInTableViewCell: MainScreenFirstSectionTableViewCell)
}



/// 현재 상영중인 영화 목록 컬렉션뷰셀을 포함한 셀
class MainScreenFirstSectionTableViewCell: UITableViewCell {
    
    /// 현재 상영중인 영화 목록 컬렉션뷰
    @IBOutlet weak var firstSectionCollectionView: UICollectionView!
    
    /// CollectionViewCellDelegate 델리게이트 속성
    weak var cellDelegate: CollectionViewCellDelegate?
    
    
    /// 컬렉션뷰를 reload합니다.
    func reloadCollectionViewData() {
        firstSectionCollectionView.reloadData()
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstSectionCollectionView.dataSource = self
        firstSectionCollectionView.delegate = self
    }
}



/// 현재 상영중인 영화 목록 컬렉션뷰 데이터 관리
extension MainScreenFirstSectionTableViewCell: UICollectionViewDataSource {
    
    /// 섹션의 아이템 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 현재 상영중인 영화 목록 컬렉션뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 아이템 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieDataManager.shared.nowPlayingMovieList.count
    }
    
    
    /// 다운로드한 이미지로 셀을 구성합니다.
    /// - Parameters:
    ///   - collectionView: 현재 상영중인 영화 목록 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 구성한 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenFirstSectionCollectionViewCell", for: indexPath) as! MainScreenFirstSectionCollectionViewCell
        
        let movieList = MovieDataManager.shared.nowPlayingMovieList
        let moviePosterPath = movieList[indexPath.item].posterPath
        
        MovieImageManager.shared.loadImage(from: moviePosterPath, posterImageSize: PosterImageSize.w500.rawValue) { img in
            if let img = img {
                cell.firstSectionImageView.image = img
            } else {
                cell.firstSectionImageView.image = UIImage(named: DefaultImageName.defaultImage.rawValue)
            }
        }
        
        cell.configure(with: movieList[indexPath.item])
        
        return cell
    }
}



/// 현재 상영중인 영화 목록 컬렉션뷰의 탭 이벤트 처리
extension MainScreenFirstSectionTableViewCell: UICollectionViewDelegate {
    
    /// 셀을 탭하면 셀의 인덱스를 대리자에게 전달합니다.
    /// - Parameters:
    ///   - collectionView: 현재 상영중인 영화 목록 컬렉션뷰
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainScreenFirstSectionCollectionViewCell", for: indexPath) as! MainScreenFirstSectionCollectionViewCell
        
        cellDelegate?.collectionView(collectionviewCell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
}



/// 현재 상영중인 영화 목록 컬렉션뷰의 셀 사이즈를 지정하기 위해 추가
extension MainScreenFirstSectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    /// 셀 사이즈를 리턴합니다.
    ///
    /// 셀의 너비를 컨텐트뷰의 너비, 높이는 너비의 150%로 지정합니다.
    /// - Parameters:
    ///   - collectionView: 현재 상영중인 영화 목록 컬렉션뷰
    ///   - collectionViewLayout: layout 객체
    ///   - indexPath: 아이템의 위치를 나타내는 IndexPath
    /// - Returns: 아이템 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = contentView.frame.size.width
        let height = width * 1.5

        return CGSize(width: width, height: height)
    }
}
