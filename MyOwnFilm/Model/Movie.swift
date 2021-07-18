//
//  Movie.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/11.
//

import Foundation

struct MovieData: Codable {
    struct Results: Codable {
        let genre_ids: [Int]
        
        let overview: String
        let release_date: String
        let title: String
        let poster_path: String
        
        // 특정 키가 없는 경우 기본값 설정
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            genre_ids = (try? values.decode(Array<Int>.self, forKey: .genre_ids)) ?? []
            overview = (try? values.decode(String.self, forKey: .overview)) ?? ""
            release_date = (try? values.decode(String.self, forKey: .release_date)) ?? "날짜를 불러올 수 없습니다."
            title = (try? values.decode(String.self, forKey: .title)) ?? ""
            poster_path = (try? values.decode(String.self, forKey: .poster_path)) ?? ""
        }
    }
    
    let results: [Results]
}
