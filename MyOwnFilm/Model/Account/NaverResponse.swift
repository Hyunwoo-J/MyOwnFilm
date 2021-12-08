//
//  NaverResponse.swift
//  MyOwnFilm
//
//  Created by Hyunwoo Jang on 2021/10/27.
//

import Foundation


/// 네이버 응답 모델
struct NaverResponse: Codable {
    
    /// 응답 모델
    struct Response: Codable {
        
        /// 아이디
        let id: String
        
        /// 이메일
        let email: String
    }
    
    /// 응답 코드
    let resultcode: String
    
    /// 메시지
    let message: String
    
    /// 응답 속성
    let response: Response
}
