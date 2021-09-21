//
//  MovieImageSource.swift
//  MovieImageSource
//
//  Created by Hyunwoo Jang on 2021/08/20.
//

import Foundation
import UIKit

class MovieImageSource {
    static let shared = MovieImageSource()
    private init() { }
    
    let cache = NSCache<NSURL, UIImage>()
    
    /// 백그라운드에서 이미지를 다운로드합니다.
    /// - Parameters:
    ///   - urlString: 받아온 영화 API에서 내려온 포스터, 배경이미지 URL
    ///   - posterImageSize: 포스터 이미지 사이즈. (PosterImageSize 열거형으로 사이즈를 따로 정의해놨습니다)
    ///   - completion: 이미지를 다운로드 받고 실행할 코드
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
            #if DEBUG
            print("Cache Memory")
            #endif
        } else {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url as URL)
                    let image = UIImage(data: data)
                    #if DEBUG
                    print("Download Image")
                    #endif
                    /// 캐시에 이미지 저장
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
}