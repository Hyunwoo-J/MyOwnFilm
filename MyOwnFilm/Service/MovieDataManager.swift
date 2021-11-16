//
//  MovieDataSource.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/11.
//

import UIKit


/// 영화 데이터 매니저
class MovieDataManager {
    
    /// 싱글톤
    static let shared = MovieDataManager()
    
    /// 싱글톤
    private init() { }
    
    /// 영화 결과를 저장하기 위한 2차원 배열
    var movieLists = [[MovieData.Result]]()
    
    /// 검색한 영화 목록
    var searchMovieList = [MovieData.Result]()
    
    /// 현재 상영중인 영화 목록
    var nowPlayingMovieList = [MovieData.Result]()
    
    /// 인기있는 영화 목록
    private var popularMovieList = [MovieData.Result]()
    
    /// 액션 영화 목록
    private var actionMovieList = [MovieData.Result]()
    
    /// 코미디 영화 목록
    private var comedyMovieList = [MovieData.Result]()
    
    /// 로맨스 영화 목록
    private var ramanceMovieList = [MovieData.Result]()
    
    /// 판타지 영화 목록
    private var fantasyMovieList = [MovieData.Result]()
    
    
    /// Prefetch를 위한 속성
    /// 불러올 페이지
    var page = 0
    
    /// 패치 플래그
    private var isFetching = false
    
    /// 불러올 데이터가 더 있는지 확인
    var hasMore = true
    
    
    /// 검색 API를 호출합니다.
    /// - Parameters:
    ///   - movieName: 영화 이름
    ///   - completion: 완료 블록
    func fetchQueryMovie(about movieName: String, completion: @escaping () -> ()) {
        guard !isFetching && hasMore else { return }
        
        isFetching = true
        page += 1
        
        let urlStr = "https://api.themoviedb.org/3/search/movie?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR&page=\(page)&include_adult=false&query=\(movieName)"
        
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
                
                print(error)
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
                print(error)
            }
        }
        task.resume()
    }
    
    
    /// DispatchGroup
    let group = DispatchGroup()
    
    
    ///  요청한 API 응답을 모두 받고나서 완료 블록을 호출합니다.
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - completion: 완료 블록
    func fetchMovie(by date: String, completion: @escaping () -> ()) {
        group.enter()
        fetchNowPlayingMovie(by: date) {
            self.group.leave()
        }
        
        group.enter()
        fetchPopularMovie(by: date) {
            self.group.leave()
        }
        
        group.enter()
        fetchActionMovie(by: date) {
            self.group.leave()
        }
        
        group.enter()
        fetchComedyMovie(by: date) {
            self.group.leave()
        }
        
        group.enter()
        fetchRomanceMovie(by: date) {
            self.group.leave()
        }
        
        group.enter()
        fetchFantasyMovie() {
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    
    /// 현재 상영중인 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - completion: 완료 블록
    func fetchNowPlayingMovie(by date: String, completion: @escaping () -> ()) {
        let urlStr = "https://api.themoviedb.org/3/movie/now_playing?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR&region=KR&release_lte=\(date)"

        let url = URL(string: urlStr)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                self.nowPlayingMovieList = movieData.results
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    /// 인기작 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - completion: 완료 블록
    func fetchPopularMovie(by date: String, completion: @escaping () -> ()) {
        let urlStr = "https://api.themoviedb.org/3/movie/popular?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR&region=KR&release_lte=\(date)"

        let url = URL(string: urlStr)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                self.popularMovieList = movieData.results
                self.popularMovieList.sort { $0.releaseDate > $1.releaseDate }
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.popularMovieList)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    /// 액션 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - completion: 완료 블록
    func fetchActionMovie(by date: String, completion: @escaping () -> ()) {
        let urlStr = "https://api.themoviedb.org/3/genre/28/movies?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR&release_lte=\(date)"

        let url = URL(string: urlStr)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                self.actionMovieList = movieData.results
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.actionMovieList)
                }
            } catch {
                print(error)
            }

        }
        task.resume()
    }
    
    
    /// 코미디 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - completion: 완료 블록
    func fetchComedyMovie(by date: String, completion: @escaping () -> ()) {
        let urlStr = "https://api.themoviedb.org/3/genre/35/movies?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR&release_lte=\(date)"

        let url = URL(string: urlStr)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                self.comedyMovieList = movieData.results
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.comedyMovieList)
                }
            } catch {
                print(error)
            }

        }
        task.resume()
    }
    
    
    /// 로맨스 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - completion: 완료 블록
    func fetchRomanceMovie(by date: String, completion: @escaping () -> ()) {
        let urlStr = "https://api.themoviedb.org/3/genre/10749/movies?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR&release_lte=\(date)"

        let url = URL(string: urlStr)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                self.ramanceMovieList = movieData.results
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.ramanceMovieList)
                }
            } catch {
                print(error)
            }

        }
        task.resume()
    }
    
    
    /// 판타지 영화 데이터를 다운로드합니다.
    /// - Parameters:
    ///   - date: 기준 날짜
    ///   - completion: 완료 블록
    func fetchFantasyMovie(completion: @escaping () -> ()) {
        let urlStr = "https://api.themoviedb.org/3/genre/14/movies?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR&"

        let url = URL(string: urlStr)!

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                self.fantasyMovieList = movieData.results
                
                if self.movieLists.count != 5 {
                    self.movieLists.append(self.fantasyMovieList)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}