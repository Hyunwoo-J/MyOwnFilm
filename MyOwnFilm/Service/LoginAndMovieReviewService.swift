//
//  Service.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/12/03.
//

import Foundation
import Moya


/// 로그인, 영화관 네트워크 요청 서비스
enum LoginAndMovieReviewService {
    // 로그인
    case signup(EmailJoinPostData)
    case login(EmailLoginPostData)
    case validateToken
    
    // 영화 리뷰
    case reviewList
    case saveReview(ReviewPostData)
    case editReview(ReviewPutData)
    case removeReview(Int)
    
    // 영화관
    case movieTheaterList
}



extension LoginAndMovieReviewService: TargetType, AccessTokenAuthorizable {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://mofapi.azurewebsites.net")!
    }
    
    /// 기본 URL을 제외한 나머지 경로
    var path: String {
        switch self {
        // 로그인
        case .signup:
            return "/join/email"
        case .login:
            return "/login/email"
        case .validateToken:
            return "/validation"
        
        // 영화 리뷰
        case .reviewList, .saveReview:
            return "/review"
        case .editReview(let reviewPutData):
            return "/review/\(reviewPutData.reviewId)"
        case .removeReview(let id):
            return "/review/\(id)"
        
        // 영화관
        case .movieTheaterList:
            return "/movietheater"
        }
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        switch self {
        case .validateToken, .reviewList, .movieTheaterList:
            return .get
        case .signup, .login, .saveReview:
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
        case .validateToken, .reviewList, .removeReview, .movieTheaterList:
            return .requestPlain
        case .signup(let emailJoinPostData):
            return .requestJSONEncodable(emailJoinPostData)
        case .login(let emailLoginPostData):
            return .requestJSONEncodable(emailLoginPostData)
        case .saveReview(let reviewPostData):
            return .requestJSONEncodable(reviewPostData)
        case .editReview(let reviewPutData):
            return .requestJSONEncodable(reviewPutData)
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    /// 인증 타입
    var authorizationType: AuthorizationType? {
        .bearer
    }
}
