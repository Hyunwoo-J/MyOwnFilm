//
//  MovieDataSource.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/11.
//

import Moya
import UIKit


/// 영화 데이터 관리
class MovieDataManager {
    
    /// 싱글톤 인스턴스
    static let shared = MovieDataManager()
    private init() { }
    
    /// 네트워크 서비스 객체
    let provider = MoyaProvider<MovieDataService>()
    
    /// 검색한 영화 목록
    var searchMovieList = [MovieData.Result]()
    
    /// 영화 결과를 저장하기 위한 2차원 배열
    var movieLists = [[MovieData.Result]]()
    
    /// 현재 상영중인 영화 목록
    var nowPlayingMovieList = [MovieData.Result]()
    
    /// 인기있는 영화 목록
    private var popularMovieList = [MovieData.Result]()
    
    /// 액션 영화 목록
    private var actionMovieList = [MovieData.Result]()
    
    /// 코미디 영화 목록
    private var comedyMovieList = [MovieData.Result]()
    
    /// 로맨스 영화 목록
    private var romanceMovieList = [MovieData.Result]()
    
    /// 판타지 영화 목록
    private var fantasyMovieList = [MovieData.Result]()
    
    /// 네트워크 요청시 전달할 파라미터 객체
    let param = MovieDataService.Param()
    
    
    /// Prefetch를 위한 속성
    /// 불러올 페이지
    var page = 0
    
    /// 패치 플래그
    private var isFetching = false
    
    /// 불러올 데이터가 더 있는지 확인
    var hasMore = true
    
    
    /// DispatchGroup
    let group = DispatchGroup()
    
    
    /// 검색 API를 호출합니다.
    /// - Parameters:
    ///   - movieName: 영화 이름
    ///   - completion: 완료 블록
    func fetchQueryMovie(about movieName: String, vc: CommonViewController, completion: @escaping () -> ()) {
        guard !isFetching && hasMore else { return }
        
        isFetching = true
        page += 1
        
        let urlStr = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=ko-KR&page=\(page)&include_adult=false&query=\(movieName)"
        
        // 한글 입력도 가능하게 설정
        let urlWithPercentEscapes = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let url = URL(string: urlWithPercentEscapes!)!
        
        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            defer {
                self.isFetching = false
            }
            
            if let error = error {
                self.hasMore = false
                vc.showAlertMessage(message: error.localizedDescription)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.hasMore = false
                return
            }
            
            guard let data = data else {
                self.hasMore = false
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                self.searchMovieList.append(contentsOf: movieData.results)
                
                self.hasMore = movieData.results.count > 0
                
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                self.hasMore = false
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    /// 요청한 API 응답을 모두 받고 나서 완료 블록을 호출합니다.
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    ///   - completion: 완료 블록
    func fetchMovie(by date: String, vc: CommonViewController, completion: @escaping () -> ()) {
        group.enter()
        fetchNowPlayingMovie(by: date, vc: vc) {
            self.group.leave()
        }
        
        group.enter()
        fetchPopularMovie(by: date, vc: vc) {
            self.group.leave()
        }
        
        group.enter()
        fetchActionMovie(by: date, vc: vc) {
            self.group.leave()
        }
        
        group.enter()
        fetchComedyMovie(by: date, vc: vc) {
            self.group.leave()
        }
        
        group.enter()
        fetchRomanceMovie(by: date, vc: vc) {
            self.group.leave()
        }
        
        group.enter()
        fetchFantasyMovie(by: date, vc: vc) {
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }

    
    /// 현재 상영중인 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - vc: 완료 블록
    ///   - completion: 완료 블록
    func fetchNowPlayingMovie(by date: String, vc: CommonViewController, completion: @escaping () -> ()) {
        provider.request(.nowPlayingMovie(param)) { result in
            switch result {
            case .success(let response):
                self.nowPlayingMovieList = MovieData.parse(data: response.data, vc: vc)
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 인기 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    ///   - completion: 완료 블록
    func fetchPopularMovie(by date: String, vc: CommonViewController, completion: @escaping () -> ()) {
        provider.request(.popularMovie(param)) { result in
            switch result {
            case .success(let response):
                self.popularMovieList = MovieData.parse(data: response.data, vc: vc)
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.popularMovieList)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 액션 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    ///   - completion: 완료 블록
    func fetchActionMovie(by date: String, vc: CommonViewController, completion: @escaping () -> ()) {
        provider.request(.actionMovie(param)) { result in
            switch result {
            case .success(let response):
                self.actionMovieList = MovieData.parse(data: response.data, vc: vc)
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.actionMovieList)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 코미디 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    ///   - completion: 완료 블록
    func fetchComedyMovie(by date: String, vc: CommonViewController, completion: @escaping () -> ()) {
        provider.request(.comedyMovie(param)) { result in
            switch result {
            case .success(let response):
                self.comedyMovieList = MovieData.parse(data: response.data, vc: vc)
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.comedyMovieList)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 로맨스 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    ///   - completion: 완료 블록
    func fetchRomanceMovie(by date: String, vc: CommonViewController, completion: @escaping () -> ()) {
        provider.request(.romanceMovie(param)) { result in
            switch result {
            case .success(let response):
                self.romanceMovieList = MovieData.parse(data: response.data, vc: vc)
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.romanceMovieList)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    
    /// 판타지 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    ///   - completion: 완료 블록
    func fetchFantasyMovie(by date: String, vc: CommonViewController, completion: @escaping () -> ()) {
        provider.request(.fantasyMovie(param)) { result in
            switch result {
            case .success(let response):
                self.fantasyMovieList = MovieData.parse(data: response.data, vc: vc)
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.fantasyMovieList)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                vc.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
}
