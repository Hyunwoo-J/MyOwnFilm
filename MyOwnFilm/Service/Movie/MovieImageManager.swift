//
//  MovieImageSource.swift
//  MovieImageSource
//
//  Created by Hyunwoo Jang on 2021/08/20.
//

import UIKit


/// 영화 이미지 데이터 관리
class MovieImageManager {
    
    /// 싱글톤 인스턴스
    static let shared = MovieImageManager()
    private init() { }
    
    /// 이미지를 저장할 캐시
    let cache = NSCache<NSURL, UIImage>()
    
    
    /// 이미지를 다운로드합니다.
    /// - Parameters:
    ///   - urlString: 영화 포스터, 배경이미지 URL
    ///   - posterImageSize: 포스터 이미지 사이즈. (PosterImageSize 열거형으로 사이즈를 따로 정의해놨습니다)
    ///   - completion: 완료 블록
    func loadImage(from urlString: String, posterImageSize: String, completion: @escaping (UIImage?) -> ()) {
        let baseURL = "https://image.tmdb.org/t/p/\(posterImageSize)\(urlString)"
        
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
                    
                    // 캐시에 이미지 저장
                    guard let image = image else { return }
                    self.cache.setObject(image, forKey: url)
                    
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
