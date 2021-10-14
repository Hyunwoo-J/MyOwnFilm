//
//  ReviewPostData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


/// 서버에 리뷰를 POST할 때 사용
struct ReviewPostData: Codable {
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
