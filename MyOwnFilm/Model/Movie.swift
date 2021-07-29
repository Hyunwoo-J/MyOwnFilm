//
//  Movie.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/11.
//

import Foundation

struct MovieData: Codable {
    struct Results: Codable {
        private let backdrop_path: String?
        var backdropPath: String {
            return backdrop_path ?? "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png" // 기본값을 넣어주는 코드
        }
        
        private let genre_ids: [Int]?
        var genreIds: [Int] {
            return genre_ids ?? []
        }
        
        private let overview: String?
        var overviewStr: String {
            return overview ?? ""
        }
        private let release_date: String?
        var releaseDate: String {
            return release_date ?? ""
        }
        private let title: String?
        var titleStr: String {
            return title ?? ""
        }
        private let poster_path: String?
        var posterPath: String {
            return poster_path ?? "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"
        }
    }
    
    let results: [Results]
}


enum PosterImageSize: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
}
