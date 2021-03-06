//
//  Movie.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/07/11.
//

import Foundation


/// 영화 API 모델
struct MovieData: Codable {
    
    struct Result: Codable {
        
        /// 영화 아이디
        let id: Int
        
        
        /// 배경 이미지 경로
        private let backdrop_path: String?
        
        /// 배경 이미지 경로
        ///
        /// 값이 없을 경우, 기본값을 리턴합니다.
        var backdropPath: String {
            return backdrop_path ?? "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"
        }
        
        
        /// 장르 아이디
        private let genre_ids: [Int]?
        
        /// 장르 아이디
        ///
        /// 값이 없을 경우, 기본값을 리턴합니다.
        var genreIds: [Int] {
            return genre_ids ?? []
        }
        
        
        /// 줄거리 요약
        private let overview: String?
        
        /// 줄거리
        ///
        /// 값이 없을 경우, 기본값을 리턴합니다.
        var overviewStr: String {
            return overview ?? "줄거리 정보가 존재하지 않습니다."
        }
        
        
        /// 개봉일
        private let release_date: String?
        
        /// 개봉일
        ///
        /// 값이 없을 경우, 기본값을 리턴합니다.
        var releaseDate: String {
            return release_date ?? "날짜 정보가 존재하지 않습니다."
        }
        
        
        /// 영화 제목
        private let title: String?
        
        /// 영화 제목
        ///
        /// 값이 없을 경우, 기본값을 리턴합니다.
        var titleStr: String {
            return title ?? "영화 제목 정보가 존재하지 않습니다."
        }
        
        
        /// 포스터 이미지 경로
        private let poster_path: String?
        
        /// 포스터 이미지 경로
        ///
        /// 값이 없을 경우, 기본값을 리턴합니다.
        var posterPath: String {
            return poster_path ?? "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"
        }
    }
    
    /// 영화 데이터 목록
    let results: [Result]
    
    
    /// 영화 데이터를 파싱합니다.
    /// - Parameters:
    ///   - data: 영화 데이터
    ///   - vc: 메소드를 실행하는 뷰컨트롤러
    /// - Returns: 영화 목록
    static func parse(data: Data, vc: CommonViewController) -> [Result] {
        var list = [Result]()
        
        do {
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieData.self, from: data)
            
            list = movieData.results
        } catch {
            vc.showAlertMessage(message: error.localizedDescription)
        }
        
        return list
    }
}



extension MovieData.Result {
    init(id: Int, backdrop_Path: String, genre_ids: [Int], overview: String, release_date: String, title: String, poster_path: String) {
        self.id = id
        self.backdrop_path = backdrop_Path
        self.genre_ids = genre_ids
        self.overview = overview
        self.release_date = release_date
        self.title = title
        self.poster_path = poster_path
    }
}



/// PosterImage 크기
enum PosterImageSize: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
}



/// 영화 장르
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
