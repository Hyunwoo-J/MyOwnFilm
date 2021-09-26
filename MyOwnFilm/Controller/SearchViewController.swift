//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by Hyunwoo Jang on 2021/07/31.
//

import UIKit


/// 검색 화면과 관련된 뷰컨트롤러 클래스
class SearchViewController: CommonViewController {
    /// 서치바
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// 영화를 표시할 테이블뷰
    @IBOutlet weak var movieTableView: UITableView!
    
    /// 검색어를 저장할 변수
    var text = ""
    
    /// 상태바를 흰색으로 바꾸기 위해 추가한 메소드
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        // 화면에 진입했을 때 키보드 올리기
        searchBar.becomeFirstResponder()
        
        // 전체 백그라운드 컬러를 검정색으로 설정
        [view, movieTableView].forEach {
            $0?.backgroundColor = .black
        }
    }
}



extension SearchViewController: UITableViewDataSourcePrefetching {
    /// 데이터 소스 객체에게 설정한 인덱스 경로에서 셀에 대한 데이터를 준비하도록 지시합니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPaths: 데이터를 미리 가져올 항목의 위치를 지정하는 IndexPath
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let shared = MovieDataSource.shared
        guard indexPaths.contains(where: { $0.row >= shared.searchMovieList.count - 3 }) else { return }
        
        #if DEBUG
        print(#function, indexPaths)
        #endif
        
        shared.fetchQueryMovie(about: text) {
            self.movieTableView.reloadData()
        }
    }
}



extension SearchViewController: UITableViewDataSource {
    /// 데이터 소스 객체에게 지정된 섹션에 있는 행의 수를 물어봅니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - section: 테이블뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션에 있는 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieDataSource.shared.searchMovieList.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieTableViewCell", for: indexPath) as! SearchMovieTableViewCell
        
        let target = MovieDataSource.shared.searchMovieList[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}



extension SearchViewController: UITableViewDelegate {
    /// 델리게이트에게 셀이 선택되었음을 알립니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPath: 선택한 셀의 IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// 다른 스토리보드에 있는 뷰컨트롤러에 접근하기 위해 스토리보드 상수 생성
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.index = indexPath.row
            
            #if DEBUG
            print(vc)
            #endif
            
            vc.movieData = MovieDataSource.shared.searchMovieList[indexPath.row]
            vc.movieList = MovieDataSource.shared.searchMovieList
            
            show(vc, sender: nil)
        }
    }
}



extension SearchViewController: UISearchBarDelegate {
    /// 델리게이트에게 검색 버튼이 눌렸음을 알립니다.
    /// - Parameter searchBar: 탭한 searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        MovieDataSource.shared.searchMovieList = []
        
        guard let hasText = searchBar.text else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        MovieDataSource.shared.page = 0
        
        text = hasText
        
        movieTableView.alpha = 0
        
        MovieDataSource.shared.fetchQueryMovie(about: hasText) {
            self.movieTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.movieTableView.alpha = 1.0
            }
        }
    }
}
