//
//  ReviewPutData.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/26.
//

import Foundation


/// 서버 리뷰 PUT 모델
struct ReviewPutData: Codable {
    
    /// 리뷰 아이디
    let reviewId: Int
    
    /// 영화 아이디
    let movieId: Int
    
    /// 영화 제목
    let movieTitle: String
    
    /// 배경 이미지 경로
    let backdropPath: String?
    
    /// 포스터 이미지 경로
    let posterPath: String?
    
    /// 개봉일
    let releaseDate: String
    
    /// 별점
    let starPoint: Double
    
    /// 영화 본 날짜
    let viewingDate: String
    
    /// 영화관
    let movieTheater: String
    
    /// 같이 본 친구
    let person: String
    
    /// 메모
    let memo: String?
}
