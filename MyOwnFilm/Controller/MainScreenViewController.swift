//
//  MainScreenViewController.swift
//  MainScreenViewController
//
//  Created by Hyunwoo Jang on 2021/07/24.
//

import KeychainSwift
import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit


/// 메인 화면
class MainScreenViewController: CommonViewController {
    
    /// 메인 화면 테이블뷰
    @IBOutlet weak var mainScreenTableView: UITableView!
    
    /// Now Playing 뷰
    ///
    /// Now Playing 글씨를 표시하는 뷰입니다.
    @IBOutlet weak var nowPlayingView: UIView!
    
    /// 영화 구분 타이틀
    let titleList = ["인기작", "액션", "코미디", "로맨스", "판타지"]
    
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// 계정 설정과 관련된 액션시트를 띄웁니다.
    /// - Parameter sender: 프로필 버튼
    @IBAction func profileButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editProfileAction = UIAlertAction(title: "프로필 편집", style: .default) { _ in
            
        }
        alert.addAction(editProfileAction)
        
        let leaveAccountAction = UIAlertAction(title: "회원 탈퇴", style: .default) { _ in
            DispatchQueue.main.async {
                self.showTwoActionAlertMessageWithHandler(alertTitle: "회원 탈퇴", message: "탈퇴하시겠습니까?", okActionTitle: "회원 탈퇴", okActionStyle: .destructive)
                    .filter { $0 == .ok }
                    .map { _ in }
                    .subscribe{ _ in
                        #if DEBUG
                        print("탈퇴 완료")
                        #endif
                    }
                    .disposed(by: self.rx.disposeBag)
            }
            
        }
        alert.addAction(leaveAccountAction)
        
        let logoutAction = UIAlertAction(title: "로그아웃", style: .default) { _ in
            DispatchQueue.main.async {
                self.showTwoActionAlertMessageWithHandler(alertTitle: "로그아웃", message: "로그아웃하시겠습니까?", okActionTitle: "로그아웃", okActionStyle: .default)
                    .subscribe(onNext: { actionType in
                        switch actionType {
                        case .ok:
                            self.loginKeychain.clear()
                            
                            self.goToIntro()
                        default:
                            break
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            }
        }
        alert.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// 인트로 화면으로 돌아갑니다.
    private func goToIntro() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
                self.show(vc, sender: nil)
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 지정한 날짜의 영화 데이터를 가져옵니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieDataManager.shared.fetchMovie(by: Date().releaseDate, vc: self) {
            self.mainScreenTableView.reloadData()
        }
    }
}



extension MainScreenViewController: CollectionViewCellDelegate {
    
    /// 선택한 테이블뷰 셀에 있는 컬렉션뷰의 인덱스를 가져옵니다.
    /// - Parameters:
    ///   - collectionviewCell: 현재 상영중인 영화 목록 컬렉션뷰 셀
    ///   - index: 컬렉션뷰의 인덱스
    ///   - didTappedInTableViewCell: 현재 상영중인 영화 목록 컬렉션뷰셀을 포함한 테이블뷰 셀
    func collectionView(collectionviewCell: MainScreenFirstSectionCollectionViewCell?, index: Int, didTappedInTableViewCell: MainScreenFirstSectionTableViewCell) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.index = index
            
            vc.movieData = MovieDataManager.shared.nowPlayingMovieList[index]
            vc.movieList = MovieDataManager.shared.nowPlayingMovieList
            
            show(vc, sender: nil)
        }
    }
}



extension MainScreenViewController: SubCollectionViewCellDelegate {
    
    /// 선택한 테이블뷰 셀에 있는 컬렉션뷰의 인덱스를 가져옵니다.
    /// - Parameters:
    ///   - collectionviewCell: 분류별 영화 목록 컬렉션뷰 셀
    ///   - index: 컬렉션뷰의 인덱스
    ///   - didTappedInTableViewCell: 분류별 영화 목록 컬렉션뷰를 포함한 테이블뷰 셀
    func collectionView(collectionviewCell: SubMovieCollectionViewCell?, index: Int, didTappedInTableViewCell: SubMovieTableViewCell) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.index = index
            
            guard let movieList = didTappedInTableViewCell.movieList else { return }
            
            vc.movieData = movieList[index]
            vc.movieList = movieList
            
            show(vc, sender: nil)
        }
    }
}



/// 메인 화면 테이블뷰 데이터 관리
extension MainScreenViewController: UITableViewDataSource {
    
    /// 섹션의 개수를 리턴합니다.
    /// - Parameter tableView: 메인 화면 테이블뷰
    /// - Returns: 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    /// 섹션에 표시할 셀 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 메인 화면 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return MovieDataManager.shared.movieLists.count
    }
    
    
    /// 섹션에 따라 셀을 구성합니다.
    ///
    /// 첫 번째 섹션에는 현재 상영중인 영화 목록을 표시하는 셀을 구성합니다.
    /// 두 번째 섹션에는 분류별 영화 목록을 표시하는 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 메인 화면 테이블뷰
    ///   - indexPath: 섹션 인덱스
    /// - Returns: 구성한 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainScreenFirstSectionTableViewCell", for: indexPath) as! MainScreenFirstSectionTableViewCell
            
            cell.cellDelegate = self
            cell.reloadCollectionViewData()
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubMovieTableViewCell", for: indexPath) as! SubMovieTableViewCell
            
            cell.cellDelegate = self
            
            let target = MovieDataManager.shared.movieLists[indexPath.row]
            cell.configure(with: target, text: titleList[indexPath.row])
            
            return cell
            
        default:
            fatalError()
        }
    }
}



/// 테이블뷰를 스크롤했을 때 발생하는 이벤트 처리
extension MainScreenViewController: UIScrollViewDelegate {
    
    /// 테이블뷰를 스크롤하면 Now Playing 뷰를 숨깁니다.
    /// - Parameter scrollView: 테이블뷰 스크롤뷰
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 1 {
            nowPlayingView.isHidden = true
        } else if scrollView.contentOffset.y <= 1 {
            nowPlayingView.isHidden = false
        }
    }
}
