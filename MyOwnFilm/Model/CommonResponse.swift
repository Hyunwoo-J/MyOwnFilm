//
//  CommonResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


/// 기본 서버 응답 타입
protocol CommonResponseType {
    
    /// 응답 코드
    var code: Int { get }
    
    /// 서버 메시지
    var message: String? { get }
}



/// 계정 관련 기본 서버 응답 타입
protocol CommonAccountResponseType {
    
    /// 유저 아이디
    var userId: String? { get }
    
    /// 토큰
    var token: String? { get }
}



/// 기본 서버 응답 모델
struct CommonResponse: Codable, CommonResponseType {
    
    /// 응답 코드
    let code: Int
    
    /// 서버 메시지
    let message: String?
}
