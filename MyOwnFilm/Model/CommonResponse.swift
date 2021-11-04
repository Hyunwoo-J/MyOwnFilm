//
//  CommonResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/13.
//

import Foundation


/// 기본 서버 응답 속성을 정의
protocol CommonResponseType {
    
    /// 응답 코드
    var code: Int { get }
    
    /// 메시지
    var message: String? { get }
}



/// 기본 계정 응답 속성을 정의
protocol CommonAccountResponseType {
    
    /// 유저 ID
    var userId: String? { get }
    
    /// 토큰
    var token: String? { get }
}



/// 기본 서버 응답 모델
struct CommonResponse: Codable, CommonResponseType {
    
    /// 응답 코드
    let code: Int
    
    /// 메시지
    let message: String?
}
