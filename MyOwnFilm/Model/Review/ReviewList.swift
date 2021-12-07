//
//  ReviewListResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/14.
//

import Foundation


/// 서버 리뷰 목록 응답 모델
struct ReviewList: Codable {
    
    /// 서버 리뷰 모델
    struct Review: Codable {
        
        /// 리뷰 ID
        let reviewId: Int
        
        /// 영화 ID
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
        let movieTheater: String?
        
        /// 같이 본 친구
        let person: String
        
        /// 메모
        let memo: String?
        
        /// 업데이트 날짜
        let updateDate: String
    }
    
    /// 총 리뷰 수
    let totalCount: Int
    
    /// 리뷰 목록
    let list: [Review]
    
    /// 응답 코드
    let code: Int
    
    /// 메시지
    let message: String?
    
    
    /// 리뷰 데이터를 파싱합니다.
    /// - Parameter data: 리뷰 데이터
    /// - Returns: 리뷰 목록
    static func parse(data: Data, vc: CommonViewController) -> [Review] {
        var list = [Review]()
        
        do {
            let decoder = JSONDecoder()
            let reviewList = try decoder.decode(ReviewList.self, from: data)
            
            if reviewList.code == 200 {
                list = reviewList.list
            }
        } catch {
            vc.showAlertMessage(message: error.localizedDescription)
        }
        return list
    }
}
