//
//  LoginService.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/11/27.
//

import Foundation
import Moya


/// 로그인 네트워크 요청 서비스
enum LoginService {
    case signup(EmailJoinPostData)
    case login(EmailLoginPostData)
    case validateToken
}



extension LoginService: TargetType, AccessTokenAuthorizable {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://mofapi.azurewebsites.net")!
    }
    
    /// 기본 URL을 제외한 나머지 경로
    var path: String {
        switch self {
        case .signup:
            return "/join/email"
        case .login:
            return "/login/email"
        case .validateToken:
            return "/validation"
        }
    }
    
    /// HTTP 요청 메소드
    var method: Moya.Method {
        switch self {
        case .signup, .login:
            return .post
        case .validateToken:
            return .get
        }
    }
    
    /// HTTP 작업 유형
    var task: Task {
        switch self {
        case .signup(let emailJoinPostData):
            return .requestJSONEncodable(emailJoinPostData)
        case .login(let emailLoginPostData):
            return .requestJSONEncodable(emailLoginPostData)
        case .validateToken:
            return .requestPlain
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
