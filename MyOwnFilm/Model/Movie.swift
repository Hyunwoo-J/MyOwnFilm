//
//  Movie.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/11.
//

import Foundation


/// 영화 API에서 가져올 데이터를 정의한 구조체
struct MovieData: Codable {
    
    struct Result: Codable {
        /// 영화 Id
        let id: Int
        
        /// 배경 이미지 경로
        private let backdrop_path: String?
        /// 배경 이미지 경로의 기본값을 넣어주는 코드
        
        var backdropPath: String {
            return backdrop_path ?? "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"
        }
        
        /// 장르 아이디
        private let genre_ids: [Int]?
        
        /// 장르 아이디의 기본값을 넣어주는 코드
        var genreIds: [Int] {
            return genre_ids ?? []
        }
        
        /// 줄거리 요약
        private let overview: String?
        
        /// 줄거리 기본값을 넣어주는 코드
        var overviewStr: String {
            return overview ?? ""
        }
        
        /// 개봉일
        private let release_date: String?
        
        /// 개봉일 기본값을 넣어주는 코드
        var releaseDate: String {
            return release_date ?? ""
        }
        
        /// 영화 제목
        private let title: String?
        
        /// 영화 제목 기본값을 넣어주는 코드
        var titleStr: String {
            return title ?? ""
        }
        
        /// 포스터 이미지 경로
        private let poster_path: String?
        
        /// 포스터 이미지 경로 기본값을 넣어주는 코드
        var posterPath: String {
            return poster_path ?? "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"
        }
    }
    
    /// 영화 데이터가 담겨있는 배열
    let results: [Result]
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



/// 영화 장르 열거형
enum MovieGenre: Int {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37
}
