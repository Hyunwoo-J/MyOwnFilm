//
//  Review.swift
//  Review
//
//  Created by Hyunwoo Jang on 2021/09/13.
//

import Foundation


/// 영화에 대한 기록을 남길 항목들을 정의한 구조체
struct MovieReview {
    
    /// 기록을 구분할 id
    let reviewId: UUID
    
    /// 영화 제목
    let movieTitle: String
    
    /// 포스터 이미지 경로
    let posterPath: String
    
    /// 배경 이미지 경로
    let backdropPath: String
    
    /// 개봉일
    let releaseDate: Date
    
    /// 별점
    let starPoint: Double
    
    /// 작성한 날짜
    let date: Date
    
    /// 본 장소
    let place: String
    
    /// 같이 본 친구
    let friend: String
    
    /// 메모
    let memo: String
    
    /// 저장한 기록을 담을 배열
    static var movieReviewList = [MovieReview]()
    
    /// 최근 3개월간 저장한 기록을 담을 배열
    static var recentlyMovieReviewList = [MovieReview]()
}
