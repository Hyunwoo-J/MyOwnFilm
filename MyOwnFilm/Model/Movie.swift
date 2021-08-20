//
//  Movie.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/11.
//

import Foundation

/// 영화 API에서 가져올 데이터를 구조체로 정의
struct MovieData: Codable {
    struct Results: Codable {
        /// 배경 이미지 경로
        private let backdrop_path: String?
        var backdropPath: String {
            return backdrop_path ?? "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png" // 기본값을 넣어주는 코드
        }
        
        /// 장르 아이디
        private let genre_ids: [Int]?
        var genreIds: [Int] {
            return genre_ids ?? []
        }
        
        /// 줄거리 요약
        private let overview: String?
        var overviewStr: String {
            return overview ?? ""
        }
        
        /// 개봉일
        private let release_date: String?
        var releaseDate: String {
            return release_date ?? ""
        }
        
        /// 영화 제목
        private let title: String?
        var titleStr: String {
            return title ?? ""
        }
        
        /// 포스터 이미지 경로
        private let poster_path: String?
        var posterPath: String {
            return poster_path ?? "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"
        }
    }
    let results: [Results]
}


/// PosterImage의 크기를 정의한 열거형
enum PosterImageSize: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
}
