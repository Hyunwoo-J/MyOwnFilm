//
//  JoinResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import Foundation


/// 회원가입 응답 모델
struct JoinResponse: Codable, CommonResponseType, CommonAccountResponseType {
    
    /// 응답 코드
    var code: Int
    
    /// 서버 메시지
    var message: String?
    
    /// 유저 아이디
    var userId: String?
    
    /// 토큰
    var token: String?
}
