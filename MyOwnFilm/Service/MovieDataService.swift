//
//  MovieDataService.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/12/08.
//

import Foundation
import Moya


/// 영화 데이터 네트워크 요청 서비스
enum MovieDataService {
    
    /// 네트워크 요청시 전달할 파라미터
    struct Param {
        let api_Key: String = apiKey
        let language: String = "ko-KR"
        let region: String = "KR"
        let release_lte: String = Date().releaseDate
        
        
        var dict: [String: Any] {
            return [
                "api_key": apiKey,
                "language": language,
                "region": region,
                "release_lte": release_lte
            ]
        }
    }
    
    case nowPlayingMovie(Param)
    case popularMovie(Param)
    case actionMovie(Param)
    case comedyMovie(Param)
    case romanceMovie(Param)
    case fantasyMovie(Param)
}



extension MovieDataService: TargetType {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    /// 기본 URL을 제외한 나머지 경로
    var path: String {
        switch self {
        case .nowPlayingMovie:
            return "/movie/now_playing"
        case .popularMovie:
            return "/movie/popular"
        case .actionMovie:
            return "/genre/28/movies"
        case .comedyMovie:
            return "/genre/35/movies"
        case .romanceMovie:
            return "/genre/10749/movies"
        case .fantasyMovie:
            return "/genre/14/movies"
        }
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        return .get
    }
    
    /// HTTP 작업 유형
    var task: Task {
        switch self {
        case .nowPlayingMovie(let param), .popularMovie(let param), .actionMovie(let param), .comedyMovie(let param), .romanceMovie(let param), .fantasyMovie(let param):
            return .requestParameters(parameters: param.dict, encoding: URLEncoding.queryString)
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        return nil
    }
}
