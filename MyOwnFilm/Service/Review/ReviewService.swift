//
//  ReviewService.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/11/27.
//

import Foundation
import Moya


/// 영화 리뷰 서비스
enum ReviewService {
    case reviewList
    case saveReview(ReviewPostData)
    case editReview(ReviewPutData)
    case removeReview(Int)
}



extension ReviewService: TargetType, AccessTokenAuthorizable {
    
    /// 인증 타입
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    /// 서버 기본 URL
    var baseURL: URL {
        return URL(string: "https://mofapi.azurewebsites.net")!
    }
    
    /// 기본 URL을 제외한 나머지 경로
    var path: String {
        switch self {
        case .reviewList, .saveReview:
            return "/review"
        case .editReview(let reviewPutData):
            return "/review/\(reviewPutData.reviewId)"
        case .removeReview(let id):
            return "/review/\(id)"
        }
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        switch self {
        case .reviewList:
            return .get
        case .saveReview:
            return .post
        case .editReview:
            return .put
        case .removeReview:
            return .delete
        }
    }
    
    /// HTTP 작업 유형
    var task: Task {
        switch self {
        case .reviewList, .removeReview:
            return .requestPlain
        case .saveReview(let reviewPostData):
            return .requestJSONEncodable(reviewPostData)
        case .editReview(let reviewPutData):
            return .requestJSONEncodable(reviewPutData)
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
