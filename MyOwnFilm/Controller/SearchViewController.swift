//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by Hyunwoo Jang on 2021/07/31.
//

import UIKit


/// 검색 화면
class SearchViewController: CommonViewController {
    
    /// 영화를 검색할 서치바
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// 영화 검색 결과 테이블뷰
    @IBOutlet weak var searchMovieTableView: UITableView!
    
    /// 검색어를 저장할 속성
    var text = ""
    
    /// 상태바 스타일. 화면 전체가 검정색이라 상태바가 잘 보이지 않아서 흰색 스타일로 바꿔줬습니다.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// 터치가 발생할 때 핸들러를 캐치합니다.
    /// - Parameter sender: 탭 제스처 인식기
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }


    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
}



extension SearchViewController: UITableViewDataSourcePrefetching {
    
    /// 영화 데이터를 미리 다운로드합니다.
    /// - Parameters:
    ///   - tableView: 영화 검색 결과 테이블뷰
    ///   - indexPaths: 데이터를 미리 가져올 항목의 위치를 지정하는 IndexPath 배열
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let shared = MovieDataManager.shared
        guard indexPaths.contains(where: { $0.row >= shared.searchMovieList.count - 3 }) else { return }
        
        #if DEBUG
        print(#function, indexPaths)
        #endif
        
        shared.fetchQueryMovie(about: text, vc: self) {
            self.searchMovieTableView.reloadData()
        }
    }
}



/// 영화 검색 결과 테이블뷰 데이터 관리
extension SearchViewController: UITableViewDataSource {
    
    /// 섹션 행의 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 영화 검색 결과 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieDataManager.shared.searchMovieList.count
    }
    
    
    /// 검색 결과로 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 영화 검색 결과 테이블뷰
    ///   - indexPath: 섹션 인덱스
    /// - Returns: 영화 검색 결과 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieTableViewCell", for: indexPath) as! SearchMovieTableViewCell
        
        let target = MovieDataManager.shared.searchMovieList[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}



/// 영화 검색 결과 테이블뷰 탭 이벤트 처리
extension SearchViewController: UITableViewDelegate {
    
    /// 셀을 탭하면 영화 상세 정보 화면으로 이동합니다.
    /// - Parameters:
    ///   - tableView: 영화 검색 결과 테이블뷰
    ///   - indexPath: 섹션 인덱스
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 다른 스토리보드에 있는 뷰컨트롤러에 접근하기 위해 스토리보드 상수 생성
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.index = indexPath.row
            
            #if DEBUG
            print(vc)
            #endif
            
            vc.movieData = MovieDataManager.shared.searchMovieList[indexPath.row]
            vc.movieList = MovieDataManager.shared.searchMovieList
            
            show(vc, sender: nil)
        }
    }
}



/// 검색 버튼을 클릭했을 때 발생하는 이벤트 처리
extension SearchViewController: UISearchBarDelegate {
    
    /// 검색 버튼을 클릭한 다음 호출됩니다.
    ///
    /// 입력한 텍스트로 영화를 다운로드하고 테이블뷰에 표시합니다.
    /// - Parameter searchBar: 서치바
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        MovieDataManager.shared.searchMovieList = []
        MovieDataManager.shared.hasMore = true
        
        searchMovieTableView.reloadData()
        
        guard let hasText = searchBar.text, hasText.count > 0 else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        MovieDataManager.shared.page = 0
        
        text = hasText
        
        searchMovieTableView.alpha = 0
        
        MovieDataManager.shared.fetchQueryMovie(about: hasText, vc: self) {
            self.searchMovieTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.searchMovieTableView.alpha = 1.0
            }
        }
    }
}
