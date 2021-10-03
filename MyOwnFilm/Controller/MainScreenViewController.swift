//
//  MainScreenViewController.swift
//  MainScreenViewController
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import UIKit


/// 메인 화면을 표시하는 화면과 관련된 뷰컨트롤러 클래스
class MainScreenViewController: CommonViewController {
    /// 메인 화면 테이블뷰
    @IBOutlet weak var mainScreenTableView: UITableView!
    
    /// Now Playing 글자를 표시하는 View
    @IBOutlet weak var nowPlayingView: UIView!
    
    /// 영화 구분 타이틀
    let titleList = ["인기작", "액션", "코미디", "로맨스", "판타지"]
    
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        // 백그라운드 색상 설정
        view.backgroundColor = .black
        mainScreenTableView.backgroundColor = .black
        
        #if DEBUG
        print(Date().releaseDate)
        #endif
        
        // 지정한 날짜의 영화 데이터를 가져옵니다.
        MovieDataSource.shared.fetchMovie(by: Date().releaseDate) {
            self.mainScreenTableView.reloadData()
        }
    }
}



extension MainScreenViewController: CollectionViewCellDelegate {
    /// 델리게이트에게 선택된 테이블뷰 셀에 있는 컬렉션뷰의 인덱스를 알립니다.
    /// - Parameters:
    ///   - collectionviewCell: 이 메소드를 호출하는 컬렉션뷰
    ///   - index: 컬렉션뷰의 인덱스
    ///   - didTappedInTableViewCell: 선택된 테이블뷰 셀
    func collectionView(collectionviewCell: MainScreenFirstSectionCollectionViewCell?, index: Int, didTappedInTableViewCell: MainScreenFirstSectionTableViewCell) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.index = index
            
            vc.movieData = MovieDataSource.shared.nowPlayingMovieList[index]
            vc.movieList = MovieDataSource.shared.nowPlayingMovieList
            
            show(vc, sender: nil)
        }
    }
}



extension MainScreenViewController: SubCollectionViewCellDelegate {
    /// 델리게이트에게 선택된 테이블뷰 셀에 있는 컬렉션뷰의 인덱스를 알립니다.
    /// - Parameters:
    ///   - collectionviewCell: 이 메소드를 호출하는 컬렉션뷰
    ///   - index: 컬렉션뷰의 인덱스
    ///   - didTappedInTableViewCell: 선택된 테이블뷰 셀
    func collectionView(collectionviewCell: SubMovieCollectionViewCell?, index: Int, didTappedInTableViewCell: SubMovieTableViewCell) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.index = index
            
            guard let movieList = didTappedInTableViewCell.movie else { return }
            
            vc.movieData = movieList[index]
            vc.movieList = movieList
            
            show(vc, sender: nil)
        }
    }
}



extension MainScreenViewController: UITableViewDataSource {
    /// 데이터 소스 객체엑 테이블뷰 섹션의 개수를 요청합니다.
    /// - Parameter tableView: 이 메소드를 호출하는 테이블뷰
    /// - Returns: 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    /// 데이터 소스 객체에게 지정된 섹션에 있는 행의 수를 물어봅니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - section: 테이블뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션에 있는 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return MovieDataSource.shared.movieLists.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainScreenFirstSectionTableViewCell", for: indexPath) as! MainScreenFirstSectionTableViewCell
            
            cell.cellDelegate = self
            
            let target = MovieDataSource.shared.nowPlayingMovieList
            cell.configure(with: target)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubMovieTableViewCell", for: indexPath) as! SubMovieTableViewCell
            
            cell.cellDelegate = self
            
            let target = MovieDataSource.shared.movieLists[indexPath.row]
            cell.configure(with: target, text: titleList[indexPath.row])
            
            return cell
            
        default:
            fatalError()
        }
    }
}



extension MainScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 1 {
            nowPlayingView.isHidden = true
        } else if scrollView.contentOffset.y <= 1 {
            nowPlayingView.isHidden = false
        }
    }
}
