//
//  ReviewPostData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


struct MovieReviewPostData: Codable {
    let movieTitle: String
    
    let posterPath: String?
    let backdropPath: String?
    
    let releaseDate: String
    let starPoint: Double
    let viewingDate: String
    let person: String
    let memo: String?
    
    let updateDate: String
}
