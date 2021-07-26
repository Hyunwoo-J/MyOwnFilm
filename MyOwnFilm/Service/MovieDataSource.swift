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
    
    var nowPlayingMovieList = [MovieData.Results]()
    var popularMovieList = [MovieData.Results]()
    var actionMoveList = [MovieData.Results]()
    
    let cache = NSCache<NSURL, UIImage>()
    
    
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
    
    let group = DispatchGroup()
    
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
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
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
                self.popularMovieList.sort { $0.release_date > $1.release_date }
            } catch {
                print(error)
            }

        }
        
        task.resume()
        
    }
    
    
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
                
                self.actionMoveList.append(contentsOf: movieData.results)
//                self.actionMoveList.sort { $0.release_date < $1.release_date }
            } catch {
                print(error)
            }

        }
        
        task.resume()
        
    }
}
