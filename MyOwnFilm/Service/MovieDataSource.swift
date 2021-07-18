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
    
    
    var movieList = [MovieData.Results]()
    
    let cache = NSCache<NSURL, UIImage>()
    
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> ()) {
        let baseURL = "https://image.tmdb.org/t/p/w500/\(urlString)"
        
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
    
    
    func fetchMovie(completion: @escaping () -> ()) {
        let urlStr = "https://api.themoviedb.org/3/movie/popular?api_key=f8fe112d01a08bb8e4e39895d7d71c61&language=ko-KR"

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
                
                self.movieList.append(contentsOf: movieData.results)
            } catch {
                print(error)
            }

        }
        
        task.resume()
        
    }
}
