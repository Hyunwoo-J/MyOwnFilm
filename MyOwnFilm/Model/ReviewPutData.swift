//
//  ReviewPutData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/26.
//

import Foundation


/// 서버에 리뷰를 PUT할 때 사용
struct ReviewPutData: Codable {
    let reviewId: Int
    let movieId: Int
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
