//
//  MovieDataSource.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/11.
//

import Foundation
import UIKit

class MovieDataSource {
    static let shared = MovieDataSource()
    private init() { }
    
    var movieLists = [[MovieData.Results]]()
    var nowPlayingMovieList = [MovieData.Results]()
    var popularMovieList = [MovieData.Results]()
    var actionMovieList = [MovieData.Results]()
    var comedyMovieList = [MovieData.Results]()
    var ramanceMovieList = [MovieData.Results]()
    var fantasyMovieList = [MovieData.Results]()
    
    let cache = NSCache<NSURL, UIImage>()
    
    
    /// 백그라운드에서 이미지를 다운로드하는 메소드
    /// - Parameters:
    ///   - urlString: 받아온 영화 API에서 내려온 포스터, 배경이미지 URL
    ///   - posterImageSize: 포스터 이미지 사이즈(PosterImageSize 열거형으로 사이즈를 따로 정의해놨다.)
    ///   - completion: 이미지를 다운로드 받고 실행할 코드를 받을 파라미터
    func loadImage(from urlString: String, posterImageSize: String, completion: @escaping (UIImage?) -> ()) {
        let baseURL = "https://image.tmdb.org/t/p/\(posterImageSize)/\(urlString)"
        
        guard let url = NSURL(string: baseURL) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        if let image = cache.object(forKey: url) {
            completion(image)
            print("Cache Memory")
        } else {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url as URL)
                    let image = UIImage(data: data)
                    print("Download Image")
                    
                    // 캐시에 이미지 저장
                    guard let image = image else { return }
                    self.cache.setObject(image, forKey: url)
                    
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // fetchMovie에서 사용할 DispatchGroup
    let group = DispatchGroup()
    
    ///  API를 모두 호출하고 나서 테이블뷰를 업데이트 하기 위해 생성한 메소드
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - completion: API를 불러오고 나서 호출할 코드를 받을 파라미터
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
    
    /// 현재 상영중인 영화 API를 받아오는 메소드
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - completion: API를 불러오고 나서 호출할 코드를 받을 파라미터
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
                
                self.nowPlayingMovieList.append(contentsOf: movieData.results)
//                self.nowPlayingMovieList.sort { $0.release_date < $1.release_date }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    /// 인기작 영화 API를 받아오는 메소드
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - completion: API를 불러오고 나서 호출할 코드를 받을 파라미터
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
                
                self.popularMovieList.append(contentsOf: movieData.results)
                self.popularMovieList.sort { $0.releaseDate > $1.releaseDate }
                self.movieLists.append(self.popularMovieList)
            } catch {
                print(error)
            }

        }
        
        task.resume()
        
    }
    
    /// 액션 영화 API를 받아오는 메소드
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - completion: API를 불러오고 나서 호출할 코드를 받을 파라미터
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
                
                self.actionMovieList.append(contentsOf: movieData.results)
                self.movieLists.append(self.actionMovieList)
            } catch {
                print(error)
            }

        }
        
        task.resume()
        
    }
    
    /// 코미디 영화 API를 받아오는 메소드
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - completion: API를 불러오고 나서 호출할 코드를 받을 파라미터
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
                
                self.comedyMovieList.append(contentsOf: movieData.results)
                self.movieLists.append(self.comedyMovieList)
            } catch {
                print(error)
            }

        }
        
        task.resume()
        
    }
    
    /// 로맨스 영화 API를 받아오는 메소드
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - completion: API를 불러오고 나서 호출할 코드를 받을 파라미터
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
                
                self.ramanceMovieList.append(contentsOf: movieData.results)
                self.movieLists.append(self.ramanceMovieList)
            } catch {
                print(error)
            }

        }
        
        task.resume()
        
    }
    
    /// 판타지 영화 API를 받아오는 메소드
    /// - Parameters:
    ///   - date: 영화를 불러올 기준 날짜
    ///   - completion: API를 불러오고 나서 호출할 코드를 받을 파라미터
    func fetchFantasyMovie(completion: @escaping () -> ()) { // by date: String
        let urlStr = "https://api.themoviedb.org/3/genre/14/movies?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR&" // release_lte=\(date)

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
                
                self.fantasyMovieList.append(contentsOf: movieData.results)
                self.movieLists.append(self.fantasyMovieList)
            } catch {
                print(error)
            }

        }
        
        task.resume()
        
    }
}
