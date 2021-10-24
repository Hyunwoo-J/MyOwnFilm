//
//  ReviewListResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/14.
//

import Foundation


/// 서버에서 리뷰를 받아올 때 사용
struct ReviewListResponse: Codable {
    struct Review: Codable {
        let reviewId: Int
        let movieTitle: String
        let posterPath: String?
        let backdropPath: String?
        let releaseDate: String
        let starPoint: Double
        let viewingDate: String
        let movieTheater: String
        let person: String
        let memo: String?
        let updateDate: String
    }
    
    let totalCount: Int
    let list: [Review]
    let code: Int
    let message: String?
}
